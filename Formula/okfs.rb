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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.9/okfs-0.1.0-pre.9-aarch64-apple-darwin.tar.gz"
      sha256 "4c8d7c1465f0ee040e4b1c173948a80bb41c9c30b299b08bb256f307b17a7ef1"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.9/okfs-0.1.0-pre.9-x86_64-apple-darwin.tar.gz"
      sha256 "5f780d0a2362f600e7f8bc6a168792aea91c43d6316c0ffdae18d86b2c6073bb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.9/okfs-0.1.0-pre.9-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2ea4774451d88d52123725a55320f89b9a9aebaace59b0df7c32d438ee8fa32e"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.9/okfs-0.1.0-pre.9-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e462d71e89bcdc9d41a994c7bff81c52475c5f8d4694ff28a273b483eed5c682"
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
