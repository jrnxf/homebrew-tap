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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.13/okfs-0.1.0-pre.13-aarch64-apple-darwin.tar.gz"
      sha256 "273ee58c9140cb6d7e4b88ee61320950a1253a3f7351348496f8343dab78ca06"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.13/okfs-0.1.0-pre.13-x86_64-apple-darwin.tar.gz"
      sha256 "6134cba4f95961225f4051d055e26d6443525a5d715e463ea1ccdf4d375cc8b4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.13/okfs-0.1.0-pre.13-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1bbf34a883ab6b08b31f4aec024323674f7825808ecef6316ca3ce21539fb561"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.13/okfs-0.1.0-pre.13-x86_64-unknown-linux-musl.tar.gz"
      sha256 "55b7d361655d7a7a6fa75c1ee14d07ae1be4e20a15a59bc4ec951a73acd0eb91"
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
