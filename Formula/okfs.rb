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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.21/okfs-0.1.0-pre.21-aarch64-apple-darwin.tar.gz"
      sha256 "84a8cb674c9f6344a0f570cd8f65e5bcfb6b56827d47911826c427846ff9686f"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.21/okfs-0.1.0-pre.21-x86_64-apple-darwin.tar.gz"
      sha256 "18b4e95188d3b729427ee4abbd01576ab2e19911a119710a0f75a8ff319b5913"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.21/okfs-0.1.0-pre.21-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9472c19b2a35149bef9c84a51f6646cdabd8eab8b98d2da32a484ab3c922e154"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.21/okfs-0.1.0-pre.21-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7c3336d6f0bbb284f7d18ff3e69e0a10beaa0a6e6811ba1fee48236821318ca5"
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
