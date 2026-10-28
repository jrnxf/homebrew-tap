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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.14/okfs-0.1.0-pre.14-aarch64-apple-darwin.tar.gz"
      sha256 "8beea8056610fa347f8f50f37be3eccc056505c1e7aff6530ecf2061b376ce43"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.14/okfs-0.1.0-pre.14-x86_64-apple-darwin.tar.gz"
      sha256 "8642822cc2185895a0688dc43fb44be45e0503fa4c5b2c1ddb80eb3125b05a53"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.14/okfs-0.1.0-pre.14-aarch64-unknown-linux-musl.tar.gz"
      sha256 "51076ed7ca38021bc1754f6472776fb7bdd9e745e5cb1318d0dfe19d7fc2350b"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.14/okfs-0.1.0-pre.14-x86_64-unknown-linux-musl.tar.gz"
      sha256 "300172dbccba49ab56954bbbf4bb6d6c54745362c82cc09438fe9128afbdc7fb"
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
