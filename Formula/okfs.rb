class Okfs < Formula
  desc "Web file browser: run it in a folder and flip through every file inside"
  homepage "https://github.com/jrnxf/okfs"
  license "MIT"

  head do
    url "https://github.com/jrnxf/okfs.git", branch: "main"

    # build.rs builds the page in ui/ with bun before cargo embeds it
    depends_on "oven-sh/bun/bun" => :build
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.25/okfs-0.1.0-pre.25-aarch64-apple-darwin.tar.gz"
      sha256 "75dfd120718d934ef32e2f90e3f9960ac36d401166ac6b2fad1517777efea585"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.25/okfs-0.1.0-pre.25-x86_64-apple-darwin.tar.gz"
      sha256 "b4e82ab660127d56194cd820e3c79cbf0ef182d47ceb9e515e6ce017c3fc6f6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.25/okfs-0.1.0-pre.25-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5c93487dbf6368a3c654bc697518b641757927322a509473d94bd461848422a3"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.25/okfs-0.1.0-pre.25-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8fd4c1156cb19357926d15abda0fe9d3836f107660c3911c7d61ea04098ecd90"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
      generate_completions_from_executable(bin/"okfs", "completions")
      (man1/"okfs.1").write Utils.safe_popen_read(bin/"okfs", "manpage")
    else
      # A release is one archive per system and architecture, holding a static binary, its shell
      # completions and its man page.
      bin.install "okfs"
      bash_completion.install "completions/okfs.bash" => "okfs"
      zsh_completion.install "completions/_okfs"
      fish_completion.install "completions/okfs.fish"
      man1.install "okfs.1"
    end
  end

  test do
    assert_match(/okfs \d+\.\d+\.\d+/, shell_output("#{bin}/okfs --version"))
  end
end
