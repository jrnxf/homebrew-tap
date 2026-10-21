class Okfs < Formula
  desc "Web file browser: run it in a folder and flip through every file inside"
  homepage "https://github.com/jrnxf/okfs"
  license "MIT"

  head do
    url "https://github.com/jrnxf/okfs.git", branch: "main"

    # build.rs builds the page in ui/ with bun before cargo embeds it
    depends_on "oven-sh/bun/bun" => :build
    depends_on "rust" => :build
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
    else
      # A release is one static binary per system and architecture, named after its target. It
      # downloads without its executable bit, which the completions below need to run it.
      asset = File.basename(stable.url)
      chmod 0755, asset
      bin.install asset => "okfs"
    end
    generate_completions_from_executable(bin/"okfs", "completions")
    (man1/"okfs.1").write Utils.safe_popen_read(bin/"okfs", "manpage")
  end

  test do
    assert_match(/okfs \d+\.\d+\.\d+/, shell_output("#{bin}/okfs --version"))
  end
end
