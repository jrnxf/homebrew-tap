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
      url "https://github.com/jrnxf/thokr/releases/download/v0.7.0/thokr-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "3f37b348ae47c8a2d5c7c155e6c6bcaab8389dde6b1649d87b84d9d0d8ec2e29"
    end
    on_intel do
      url "https://github.com/jrnxf/thokr/releases/download/v0.7.0/thokr-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "ad40778a50e1d447cee2b6833a611399f58e8285e286928def7183db60e3ff96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/thokr/releases/download/v0.7.0/thokr-0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0798e4f119be9a4eafbedde3d131da29a355c3871d956afb77fd9e09046e1a40"
    end
    on_intel do
      url "https://github.com/jrnxf/thokr/releases/download/v0.7.0/thokr-0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f890b86c7fb13260ca31cad98191bda399814f0bb107cb339e9502165b7e57ed"
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
