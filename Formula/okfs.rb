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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.24/okfs-0.1.0-pre.24-aarch64-apple-darwin.tar.gz"
      sha256 "ae4c144d59d6b32aea1b10c3866a043a5ef1ca51f2912ae96308bdba5712176b"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.24/okfs-0.1.0-pre.24-x86_64-apple-darwin.tar.gz"
      sha256 "0baff9e9c23453ffab2f0f9aae87979520fbf46287b5bc10edfce5ee1f4a42d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.24/okfs-0.1.0-pre.24-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a9e6ca7c97577b2c933c3ca056bc8fdae7933b7571981384c978d3e4e93ebf1b"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.24/okfs-0.1.0-pre.24-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1585604bc5f496b795bf4eeaccffc9eaadd3db4af9d5c921884997463446beac"
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
