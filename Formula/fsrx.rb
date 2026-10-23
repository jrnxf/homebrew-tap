class Fsrx < Formula
  desc "Flow state reading in the terminal"
  homepage "https://github.com/jrnxf/fsrx"
  url "https://github.com/jrnxf/fsrx/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "940aed8e047eab5e4fa452970854fef7ccf38959dc5a6c86416915208f5b9de4"
  license "MIT"
  head "https://github.com/jrnxf/fsrx.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fsrx --version")
  end
end
