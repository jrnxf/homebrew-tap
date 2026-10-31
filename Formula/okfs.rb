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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.16/okfs-0.1.0-pre.16-aarch64-apple-darwin.tar.gz"
      sha256 "6702f88ade703bee79488c28d7b5e0a4f9c1a08531c4f60c4f38e7b5b65bb7a0"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.16/okfs-0.1.0-pre.16-x86_64-apple-darwin.tar.gz"
      sha256 "8778c73cd4893b71579fde7822bd0a634d6eefd940e2d9c9d7005b916e49bf93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.16/okfs-0.1.0-pre.16-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef86503a2b11a750887bb9e7bd4a54d210080b0c5fc53dc09cacd0ebfc71cdbb"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.16/okfs-0.1.0-pre.16-x86_64-unknown-linux-musl.tar.gz"
      sha256 "37e125eb35f78e2042b99a00b3373dbf88b870f493ddb940dad5e4f6d8db1cb2"
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
