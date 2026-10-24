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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.11/okfs-0.1.0-pre.11-aarch64-apple-darwin.tar.gz"
      sha256 "b3079636fc2f5b76a146e15e6851132a5db6b5f3f35dbf096fbb97c2f57d0203"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.11/okfs-0.1.0-pre.11-x86_64-apple-darwin.tar.gz"
      sha256 "448ffea7cc2bf7a6057c7c8f755a2b11f9f76e4b4fb2ebaad9d5b992fb9d34cc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.11/okfs-0.1.0-pre.11-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3e97950606014ebb277c6f760bc77c444fdeca1e2e0e04322dd1ec849745fbed"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.11/okfs-0.1.0-pre.11-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7c9780d35027c0acf9fef1ce808b899d14770a4e64ed877f42e335a5d4afab26"
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
