class Drip < Formula
  desc "HUD from the shell for macOS: a brief native card from the notch"
  homepage "https://github.com/jrnxf/drip"
  url "https://github.com/jrnxf/drip/releases/download/v0.1.0-pre.2/drip-0.1.0-pre.2-universal-apple-darwin.tar.gz"
  sha256 "f20cc90689b578ecda18b22a193f6100eb5f1cb6dbf45ade5779d31da7f833db"
  license "MIT"
  head "https://github.com/jrnxf/drip.git", branch: "main"

  depends_on macos: :ventura

  def install
    if build.head?
      system "swift", "build", "--disable-sandbox", "-c", "release"
      bin.install ".build/release/drip"
    else
      # A release is one archive holding a universal binary, for Apple silicon and Intel.
      bin.install "drip"
    end
    # The notices for what drip bundles, which must ship with every copy. brew keeps LICENSE and
    # README.md on its own, but not this.
    prefix.install "THIRD_PARTY.md"
  end

  def caveats
    <<~EOS
      Run `drip ok "hello"` to see a card drop from the notch.
      Run `drip setup claude` (or codex, or gemini) to get a card when an agent needs you.
    EOS
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/drip --version"))
  end
end
