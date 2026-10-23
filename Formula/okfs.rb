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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.2/okfs-0.1.0-pre.2-aarch64-apple-darwin.tar.gz"
      sha256 "70ae1fedc7f37bfbd216633e970724decccfa3aca4df07b9791ef024ed352b9c"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.2/okfs-0.1.0-pre.2-x86_64-apple-darwin.tar.gz"
      sha256 "ea6e789fd436c3c0124327676056b135b56bd67c5ebf9973d3b051ec40d0b807"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.2/okfs-0.1.0-pre.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d3a3e73d81fb34867499a1f99557b962392e5d6db99ecdba66b1c78bd8938d78"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.2/okfs-0.1.0-pre.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2b2aed6def4623700a517bf7fcca7eb54f60b643d58d711f4091e1859ae2f9ab"
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
