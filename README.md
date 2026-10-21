# homebrew-tap

Homebrew formulas for jrnxf's tools.

```sh
brew install jrnxf/tap/thokr
```

## Formulas

- `thokr`: sleek typing tui with visualized results and historical logging
- `drip`: HUD from the shell for macOS. No release yet, so install its latest `main` with `brew install --HEAD jrnxf/tap/drip` and update it with `brew reinstall drip`. From v0.1.0, `brew install jrnxf/tap/drip` downloads its prebuilt universal binary, for Apple silicon and Intel, with nothing to compile.
- `okfs`: web file browser. No release yet, so install its latest `main` with `brew install --HEAD jrnxf/tap/okfs` and update it with `brew reinstall okfs`. From v0.1.0, `brew install jrnxf/tap/okfs` downloads its prebuilt binary for macOS or Linux, on ARM or x86-64, with its shell completions and man page, and nothing to compile.

## Adding a formula

To have a project update its formula on every release, see [Updating a formula from a project's release](docs/automatic-updates.md).

## Updating a formula

`scripts/bump-formula.sh` points a formula at a release. It reads the repository address from the formula's `homepage`, which must be `https://github.com/<owner>/<repo>`, and expects the release tag to be `v<version>`. A leading `v` on the version argument is accepted. It has two modes.

### Source archive

With only a formula and a version, the formula builds from the tag's source archive:

```sh
scripts/bump-formula.sh thokr v0.7.0
```

This writes the top-level `url` and `sha256`, pointing at `https://github.com/<owner>/<repo>/archive/refs/tags/v<version>.tar.gz`.

### Prebuilt binaries

With `<platform>=<asset>` arguments, the formula installs files attached to the GitHub release instead:

```sh
scripts/bump-formula.sh okfs v0.1.0 \
  macos-arm=okfs-0.1.0-aarch64-apple-darwin.tar.gz \
  macos-intel=okfs-0.1.0-x86_64-apple-darwin.tar.gz \
  linux-arm=okfs-0.1.0-aarch64-unknown-linux-musl.tar.gz \
  linux-intel=okfs-0.1.0-x86_64-unknown-linux-musl.tar.gz
```

The platforms are `macos-arm`, `macos-intel`, `linux-arm` and `linux-intel`. `macos` and `linux` stand for both architectures of that system, for example a universal macOS binary. Leave out a platform the project has no binary for.

Each asset is downloaded from `https://github.com/<owner>/<repo>/releases/download/v<version>/<asset>` and hashed. When the release also has `<asset>.sha256`, its first field must match, or the script stops.

The script writes:

- one asset for every platform given (such as `macos=drip-0.1.0-universal-apple-darwin.tar.gz`): a top-level `url` and `sha256`, the same as the source mode. Use it for a formula that only runs on one system and says so, such as `depends_on macos:`.
- different assets: an `on_macos` and an `on_linux` block, each with an `on_arm` and an `on_intel` block holding that platform's `url` and `sha256`. Homebrew does not accept a `url` directly inside `on_macos` or `on_linux`.

```ruby
  on_macos do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0/okfs-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "..."
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0/okfs-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "..."
    end
  end
```

Every run replaces what the last run wrote, in either mode: the top-level `url` and `sha256`, and any `on_macos` or `on_linux` block that holds a `url`. A formula can move between the modes this way.

A formula that uses the binary mode needs a few things the script does not write:

- Homebrew allows one `on_macos` and one `on_linux` block per formula, so the formula cannot have its own block for a system the script writes one for. The script stops with an error instead.
- `def install` installs what the asset holds. An asset can be an archive or a bare file, and the script hashes it either way. brew unpacks a `.tar.gz` and steps into its one top-level directory, so with `<name>` (mode 0755) at the top of the archive, `bin.install "okfs"` works for every platform. A bare binary downloads without its executable bit, and brew does not add one, so it needs `chmod 0755` and a rename.
- If the formula keeps `head` to build from source, its build dependencies go in a `head do` block with the `url` of the repository, so a binary install does not pull them in. `def install` then checks `build.head?` to choose between building and installing the binary.
