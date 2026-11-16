class Drip < Formula
  desc "HUD from the shell for macOS: a brief native card from the notch"
  homepage "https://github.com/jrnxf/drip"
  url "https://github.com/jrnxf/drip/releases/download/v0.1.0-pre.32/drip-0.1.0-pre.32-universal-apple-darwin.tar.gz"
  sha256 "1b58479ecea40d0eda56f40082a1694dd4573eb0e4174c661a459e1ea5899399"
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
      # The man page, once the archive holds one: releases before it do not.
      man1.install "drip.1" if File.exist?("drip.1")
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
