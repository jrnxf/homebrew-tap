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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.19/okfs-0.1.0-pre.19-aarch64-apple-darwin.tar.gz"
      sha256 "9e6885d62812fb5d8d12815a9c2480b79d7a26f786bbaf780101ed16d27bd86f"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.19/okfs-0.1.0-pre.19-x86_64-apple-darwin.tar.gz"
      sha256 "7fe269bef254f4acbdd5181a1a285b7495332760541440e0fbc9feeddd9ff41a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.19/okfs-0.1.0-pre.19-aarch64-unknown-linux-musl.tar.gz"
      sha256 "19c7d566925ce5cb688f951486b3fffc4237a47ec34bc2722c5cfdf202a4c418"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.19/okfs-0.1.0-pre.19-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6d32429bba65bbaf8401524de2cea49aa190e17838be33bde3559d8150609482"
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
