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
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.1/fsrx-1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "131d2b05511b2b0c278fae8063b884c8a6899bd83aea6aefee21762f81ee44e6"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.1/fsrx-1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "d7cccab038f4839c7cc4173758b74986f7213320b005a0fff84d398aefed9d54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.1/fsrx-1.1.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "79eed86010c483375b5cece0abc7aa789b66b1f7093aec0ba11de61ad4b5d9e2"
    end
    on_intel do
      url "https://github.com/jrnxf/fsrx/releases/download/v1.1.1/fsrx-1.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ad2da6960463afdca69e1231672a1172c5de27766b6245203f2ebd2ba9690523"
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
