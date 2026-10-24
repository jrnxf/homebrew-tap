class Fsrx < Formula
  desc "Flow state reading in the terminal"
  homepage "https://github.com/jrnxf/fsrx"
  license "MIT"

  head do
    url "https://github.com/jrnxf/fsrx.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.0/fsrx-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "c533536c04b75c5107edea89679d1921f5859ef4963939663e0dc7f0a928314b"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.0/fsrx-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "869c3d9f0d19aee9b3923d6c6f6a06fa6c08b2d0250a3c0d159efa694e865152"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.0/fsrx-1.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e65d6c2ec3025b14b4927fde6188b0fb937362ce30d1820703079b7d38edaed7"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.0/fsrx-1.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a92450561b03b32120babc71f7e9216da66bf4ad0e5b4bf3656a96399f3227a0"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      # A release is one archive per system and architecture, holding a prebuilt binary.
      bin.install "fsrx"
    end
  end

  test do
    assert_match(/fsrx \d+\.\d+\.\d+/, shell_output("#{bin}/fsrx --version"))
  end
end
