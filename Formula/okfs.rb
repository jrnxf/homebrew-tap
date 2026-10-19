class Okfs < Formula
  desc "Web file browser: run it in a folder and flip through every file inside"
  homepage "https://github.com/jrnxf/okfs"
  license "MIT"
  head "https://github.com/jrnxf/okfs.git", branch: "main"

  # build.rs builds the page in ui/ with bun before cargo embeds it
  depends_on "oven-sh/bun/bun" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/okfs \d+\.\d+\.\d+/, shell_output("#{bin}/okfs --version"))
  end
end
