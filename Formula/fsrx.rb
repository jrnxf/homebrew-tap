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
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.2/fsrx-1.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "f9d746525e5af8eed08aee95cc050b6dc0ced58340fc6a2a46d7789cb7f0c704"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.2/fsrx-1.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "033081eff89b45eb3d0885a85b9a65cdbbba7b359cb402860d6be17eef5568e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.2/fsrx-1.1.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b03021d579f2c18c636528395d27cdfe8b33eaacb43ae40586df2d7583a1c061"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.2/fsrx-1.1.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5934cd6587fc2851a46a05f4dcb78476e66f5821d59fd1c6e4f1eba9f20905b0"
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
