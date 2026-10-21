class Drip < Formula
  desc "HUD from the shell for macOS: a brief native card from the notch"
  homepage "https://github.com/jrnxf/drip"
  license "MIT"
  head "https://github.com/jrnxf/drip.git", branch: "main"

  depends_on macos: :ventura

  def install
    if build.head?
      system "swift", "build", "--disable-sandbox", "-c", "release"
      bin.install ".build/release/drip"
    else
      # A release is one universal binary, for Apple silicon and Intel. It downloads without its
      # executable bit, which brew would not add.
      chmod 0755, "drip-universal-apple-darwin"
      bin.install "drip-universal-apple-darwin" => "drip"
    end
  end

  def caveats
    <<~EOS
      Run `drip demo` to watch a few cards drop from the notch.
      Run `drip setup claude` (or codex, or gemini) to get a card when an agent needs you.
    EOS
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/drip --version"))
  end
end
