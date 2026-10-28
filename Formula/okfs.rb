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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.15/okfs-0.1.0-pre.15-aarch64-apple-darwin.tar.gz"
      sha256 "a59faa07883cfdc6eb716abaf7386e6268efdb732b2b5a2d6834b8818e45cded"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.15/okfs-0.1.0-pre.15-x86_64-apple-darwin.tar.gz"
      sha256 "708aec559fa0ad88d94d0f1ce3bd7de75c8a4bf3716919057ed22583f9466e27"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.15/okfs-0.1.0-pre.15-aarch64-unknown-linux-musl.tar.gz"
      sha256 "75e21fb835508d487a1c345ac4b8bc7f8357af60d67ce9d7ba3d7a2e40c0b8c4"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.15/okfs-0.1.0-pre.15-x86_64-unknown-linux-musl.tar.gz"
      sha256 "37c92ddaa0a3d32c02b6eef22246e51979b7d09ecd3be1503e8bffe1daa4304d"
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
