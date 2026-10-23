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
      url "https://github.com/jrnxf/fsrx/releases/download/v1.0.3/fsrx-1.0.3-aarch64-apple-darwin.tar.gz"
      sha256 "f07b75137432c65d351ec5ded5424c34f291ca49690187667e59dc012e3381cd"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.0.3/fsrx-1.0.3-x86_64-apple-darwin.tar.gz"
      sha256 "2fd6f55755930e40d819c925152891c55fc48cdb09530f5106935fce2413cc12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.0.3/fsrx-1.0.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "99307e6855c5e6bb14a485a4cb2f0f42bab7a960431b95763e0d540882106184"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.0.3/fsrx-1.0.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "41500a8526b066e8b384ee4b52d55dbe17ff8168b88deec59c69c13f72bb602c"
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
