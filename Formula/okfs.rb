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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.28/okfs-0.1.0-pre.28-aarch64-apple-darwin.tar.gz"
      sha256 "a4f3d971735cf77267b2cc0bce11d44e42b47e7d8862bc273f8fee29a46f1174"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.28/okfs-0.1.0-pre.28-x86_64-apple-darwin.tar.gz"
      sha256 "1c36a71dcac70cb235fd1865e64cb11f370517d5b0a9df2c9d0774d0193611a2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.28/okfs-0.1.0-pre.28-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bd1911c8f1fde72e727b8cab063de547f14ec88dfb1b8473c62e8f49d11b1449"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.28/okfs-0.1.0-pre.28-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5ca3635327d4f2f9e81c638938c5035edea64ce9c5d793efc3883416ea8fba76"
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
