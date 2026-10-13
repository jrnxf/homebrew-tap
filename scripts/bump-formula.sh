#!/bin/sh
# Point a formula at the source archive of a release tag.
# usage: scripts/bump-formula.sh <formula> <version>   (e.g. thokr 0.7.0 or thokr v0.7.0)
# The release address is read from the formula's homepage, so it works for any
# formula whose source is a GitHub tag archive.
set -eu

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <formula> <version>" >&2
  exit 1
fi

name="$1"
version="${2#v}"
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

url="${homepage}/archive/refs/tags/v${version}.tar.gz"

tmp="$(mktemp)"
trap 'rm -f "$tmp" "$tmp.new"' EXIT

curl -fsSL "$url" -o "$tmp"

if command -v sha256sum >/dev/null 2>&1; then
  sha="$(sha256sum "$tmp" | cut -d ' ' -f 1)"
else
  sha="$(shasum -a 256 "$tmp" | cut -d ' ' -f 1)"
fi

sed -e "s|^  url \".*\"|  url \"${url}\"|" \
    -e "s|^  sha256 \".*\"|  sha256 \"${sha}\"|" \
    "$formula" > "$tmp.new"
cat "$tmp.new" > "$formula"

echo "Formula/${name}.rb -> v${version} (${sha})"
