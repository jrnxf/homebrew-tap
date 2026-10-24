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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.10/okfs-0.1.0-pre.10-aarch64-apple-darwin.tar.gz"
      sha256 "41c401d40f99eb2f8042c96df3cad1407773a9c1068b79390605c828e2f5b2ec"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.10/okfs-0.1.0-pre.10-x86_64-apple-darwin.tar.gz"
      sha256 "bad1390e8baf9b154105f216080e8b1fc0f537c47098c59f2d48367e0b2a385c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.10/okfs-0.1.0-pre.10-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aef0cda6d607fb4af69366a01b123b7b7b7bbc7821a2f18d872d64edbdccb460"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.10/okfs-0.1.0-pre.10-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9130b287f8bbb51772937e6d2aabfd798856e5647596def94a8cf5bf91936d5e"
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
