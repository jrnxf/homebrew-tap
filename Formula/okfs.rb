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

  on_macos do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.33/okfs-0.1.0-pre.33-aarch64-apple-darwin.tar.gz"
      sha256 "266619694b3af188f51e60dcf52e7c23251760cca272a07e14b501eaa3830987"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.33/okfs-0.1.0-pre.33-x86_64-apple-darwin.tar.gz"
      sha256 "a6a424133ecd2804ad49d22f01669bdf68c3ae5c4693881d3380d3558ef325b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.33/okfs-0.1.0-pre.33-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b815c3e1ebcb8fdbb95d03a41b14d10473e21e0b37537333f42103d3e7f900d7"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.33/okfs-0.1.0-pre.33-x86_64-unknown-linux-musl.tar.gz"
      sha256 "05f0d9d67b25f2b4902b780826c5d300c396260c656b7a31491fe5066f7ebd6d"
    end
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args
      generate_completions_from_executable(bin/"okfs", "completions")
      (man1/"okfs.1").write Utils.safe_popen_read(bin/"okfs", "manpage")
    else
      # A release is one archive per system and architecture, holding a static binary, its shell
      # completions and its man page.
      bin.install "okfs"
      bash_completion.install "completions/okfs.bash" => "okfs"
      zsh_completion.install "completions/_okfs"
      fish_completion.install "completions/okfs.fish"
      man1.install "okfs.1"
    end
  end

  test do
    assert_match(/okfs \d+\.\d+\.\d+/, shell_output("#{bin}/okfs --version"))
  end
end
