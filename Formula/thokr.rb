class Thokr < Formula
  desc "sleek typing tui with visualized results and historical logging"
  homepage "https://github.com/jrnxf/thokr"
  license "MIT"

  head do
    url "https://github.com/jrnxf/thokr.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/jrnxf/thokr/releases/download/v0.6.1/thokr-0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "fe2882907e1bd118c7a2fc88a365c53b8986d589453def25093d2db62e904cec"
    end
    on_intel do
      url "https://github.com/jrnxf/thokr/releases/download/v0.6.1/thokr-0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "90dd22284e2c3e19443079bc681dd6f5da3ac8dd73a557ef561194f5d24608c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/thokr/releases/download/v0.6.1/thokr-0.6.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0dae8aa8abddf734e0c89f92b4bd9e333602b0507c0179cd3ea8cef5d47c6b39"
    end
    on_intel do
      url "https://github.com/jrnxf/thokr/releases/download/v0.6.1/thokr-0.6.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d866cf17b69c21e80d24f6411de4c13132aaf969e99ccd1d188dec206f3f7d91"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      # A release is one archive per system and architecture, holding a prebuilt binary.
      bin.install "thokr"
    end
  end

  test do
    assert_match(/thokr \d+\.\d+\.\d+/, shell_output("#{bin}/thokr --version"))
  end
end
