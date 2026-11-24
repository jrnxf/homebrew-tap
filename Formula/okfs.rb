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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.32/okfs-0.1.0-pre.32-aarch64-apple-darwin.tar.gz"
      sha256 "339fb23e5ed33938e42b00ee82fbb56ac4bad212f30416dfd4a9d55bb835928c"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.32/okfs-0.1.0-pre.32-x86_64-apple-darwin.tar.gz"
      sha256 "ca03ef1b5ea5fea36ab3dd02057a765a087ee5daaafa74934252f5e318955cfe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.32/okfs-0.1.0-pre.32-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e8d397d73dbeaae9befe419adf5f0e93a0be52a81abe40dfa65376b52bf2fc84"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.32/okfs-0.1.0-pre.32-x86_64-unknown-linux-musl.tar.gz"
      sha256 "72920c67ad6d29dbf6dc9f526e7ccfe9676b56d58bf62089f551d56735645e10"
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
