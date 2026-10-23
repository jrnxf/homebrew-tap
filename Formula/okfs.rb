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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.5/okfs-0.1.0-pre.5-aarch64-apple-darwin.tar.gz"
      sha256 "bc025d9f225870f46f07f2130127083a6749d3eceafc40b467d1281938e70a5e"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.5/okfs-0.1.0-pre.5-x86_64-apple-darwin.tar.gz"
      sha256 "c74c0b6abd511498cfe337f2751af6dbfea07357f6403da7b5d946132b2bff11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.5/okfs-0.1.0-pre.5-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8849c5f0c6eec5544a469f91360abc426ac72c2c63f8e23b3daaca69979e9dc9"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.5/okfs-0.1.0-pre.5-x86_64-unknown-linux-musl.tar.gz"
      sha256 "25ff30121a303faf8e697532b1cdc2d8784ad7eedcaa45d0c812df9a2e433c1b"
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
