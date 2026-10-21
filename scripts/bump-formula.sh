#!/bin/sh
# Point a formula at a release: its source archive, or its prebuilt binary assets.
# usage: scripts/bump-formula.sh <formula> <version> [<platform>=<asset> ...]
#   source archive:  scripts/bump-formula.sh thokr 0.7.0   (or v0.7.0)
#   binary assets:   scripts/bump-formula.sh okfs v0.1.0 macos-arm=okfs-0.1.0-aarch64-apple-darwin.tar.gz ...
# A platform is macos, linux, macos-arm, macos-intel, linux-arm or linux-intel; macos and linux
# stand for both of their architectures. The release address is read from the formula's homepage,
# so it works for any formula whose project is a GitHub repository.
set -eu

usage() {
  echo "usage: $0 <formula> <version> [<platform>=<asset> ...]" >&2
  echo "platforms: macos linux macos-arm macos-intel linux-arm linux-intel" >&2
  exit 1
}

[ "$#" -ge 2 ] || usage

name="$1"
version="${2#v}"
shift 2
formula="$(cd "$(dirname "$0")/.." && pwd)/Formula/${name}.rb"

if [ ! -f "$formula" ]; then
  echo "no such formula: Formula/${name}.rb" >&2
  exit 1
fi

homepage="$(sed -n 's|^  homepage "\(.*\)"$|\1|p' "$formula")"
case "$homepage" in
  https://github.com/*/*) ;;
  *)
    echo "homepage is not a GitHub repository address: ${homepage}" >&2
    exit 1
    ;;
esac

# One asset per platform slot; macos and linux fill both architectures of their system.
macos_arm=""
macos_intel=""
linux_arm=""
linux_intel=""
set_slot() {
  eval "current=\${$1}"
  if [ -n "$current" ]; then
    echo "more than one asset for $(echo "$1" | tr _ -)" >&2
    exit 1
  fi
  eval "$1=\$2"
}
for arg in "$@"; do
  platform="${arg%%=*}"
  asset="${arg#*=}"
  case "$arg" in *=*) ;; *) usage ;; esac
  case "$asset" in
    "" | */* | *[[:space:]]*)
      echo "not an asset file name: ${asset}" >&2
      exit 1
      ;;
  esac
  case "$platform" in
    macos) set_slot macos_arm "$asset"; set_slot macos_intel "$asset" ;;
    linux) set_slot linux_arm "$asset"; set_slot linux_intel "$asset" ;;
    macos-arm) set_slot macos_arm "$asset" ;;
    macos-intel) set_slot macos_intel "$asset" ;;
    linux-arm) set_slot linux_arm "$asset" ;;
    linux-intel) set_slot linux_intel "$asset" ;;
    *)
      echo "unknown platform: ${platform}" >&2
      usage
      ;;
  esac
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -d ' ' -f 1
  else
    shasum -a 256 "$1" | cut -d ' ' -f 1
  fi
}

# Download a release file and print its sha256. A release asset's published <asset>.sha256,
# when there is one, must agree with the file.
fetch() {
  curl -fsSL "$1" -o "$tmp/file"
  sha="$(sha256_of "$tmp/file")"
  if [ "$#" -eq 2 ]; then
    status="$(curl -sSL -o "$tmp/sum" -w '%{http_code}' "$1.sha256")"
    case "$status" in
      200)
        published="$(cut -d ' ' -f 1 "$tmp/sum" | head -n 1)"
        if [ "$published" != "$sha" ]; then
          echo "$2: sha256 is ${sha}, but $2.sha256 says ${published}" >&2
          exit 1
        fi
        ;;
      404) ;;
      *)
        echo "could not fetch $2.sha256 (HTTP ${status})" >&2
        exit 1
        ;;
    esac
  fi
  echo "$sha"
}

# A url and its sha256 at the given indent.
stanza() {
  printf '%surl "%s"\n%ssha256 "%s"\n' "$1" "$2" "$1" "$3"
}

top=""
macos=""
linux=""
if [ "$#" -eq 0 ]; then
  url="${homepage}/archive/refs/tags/v${version}.tar.gz"
  sha="$(fetch "$url")"
  top="$(stanza "  " "$url" "$sha")"
  summary=" (${sha})"
else
  base="${homepage}/releases/download/v${version}"
  : > "$tmp/shas"
  for asset in $(printf '%s\n' "$macos_arm" "$macos_intel" "$linux_arm" "$linux_intel" | sed '/^$/d' | sort -u); do
    sha="$(fetch "$base/$asset" "$asset")"
    echo "$asset $sha" >> "$tmp/shas"
  done
  summary="
$(sed 's/^/  /' "$tmp/shas")"
  sha_for() { awk -v asset="$1" '$1 == asset { print $2 }' "$tmp/shas"; }

  # One asset everywhere is a plain url. Otherwise Homebrew only takes a url inside on_arm or
  # on_intel, so each system gets a block holding one per architecture.
  if [ "$(wc -l < "$tmp/shas")" -eq 1 ]; then
    asset="$(cut -d ' ' -f 1 "$tmp/shas")"
    top="$(stanza "  " "$base/$asset" "$(sha_for "$asset")")"
  else
    system_block() {
      echo "  on_$1 do"
      if [ -n "$2" ]; then
        echo "    on_arm do"
        stanza "      " "$base/$2" "$(sha_for "$2")"
        echo "    end"
      fi
      if [ -n "$3" ]; then
        echo "    on_intel do"
        stanza "      " "$base/$3" "$(sha_for "$3")"
        echo "    end"
      fi
      echo "  end"
    }
    if [ -n "$macos_arm$macos_intel" ]; then
      macos="$(system_block macos "$macos_arm" "$macos_intel")"
    fi
    if [ -n "$linux_arm$linux_intel" ]; then
      linux="$(system_block linux "$linux_arm" "$linux_intel")"
    fi
  fi
fi

# Drop the release this script wrote last time (a top-level url and sha256, and any on_macos or
# on_linux block holding a url), then write the new one. A plain url goes after the homepage;
# system blocks go where Homebrew orders them, before conflicts, resources, patches and install.
TOP="$top" MACOS="$macos" LINUX="$linux" awk '
  function insert(text) { if (text != "") { out[++n] = text; out[++n] = "" } }
  {
    line[NR] = $0
  }
  END {
    n = 0
    for (i = 1; i <= NR; i++) {
      if (line[i] ~ /^  (url|sha256) "/) continue
      if (line[i] ~ /^  on_(macos|linux) do$/) {
        os = line[i]
        sub(/^  on_/, "", os)
        sub(/ do$/, "", os)
        for (j = i; j < NR && line[j] != "  end"; j++) ;
        held = 0
        for (k = i; k <= j; k++) if (line[k] ~ /^ +url "/) held = 1
        if (held) {
          i = j
          if (line[i + 1] == "") i++
          continue
        }
        own[os] = 1
      }
      out[++n] = line[i]
    }
    if (ENVIRON["MACOS"] != "" && own["macos"] || ENVIRON["LINUX"] != "" && own["linux"]) {
      print "the formula has its own on_macos or on_linux block; Homebrew allows one per system" > "/dev/stderr"
      exit 1
    }
    m = n
    for (i = 1; i <= m; i++) kept[i] = out[i]
    n = 0
    for (i = 1; i <= m; i++) {
      if (kept[i] ~ /^  (on_linux do|conflicts_with|fails_with|link_overwrite|skip_clean|resource|patch|def |test do)/ && !macos_done) {
        insert(ENVIRON["MACOS"])
        macos_done = 1
      }
      if (kept[i] ~ /^  (conflicts_with|fails_with|link_overwrite|skip_clean|resource|patch|def |test do)/ && !linux_done) {
        insert(ENVIRON["LINUX"])
        linux_done = 1
      }
      out[++n] = kept[i]
      if (kept[i] ~ /^  homepage "/ && ENVIRON["TOP"] != "") out[++n] = ENVIRON["TOP"]
    }
    for (i = 1; i <= n; i++) print out[i]
  }
' "$formula" > "$tmp/formula"
cat "$tmp/formula" > "$formula"

echo "Formula/${name}.rb -> v${version}${summary}"
