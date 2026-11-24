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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.26/okfs-0.1.0-pre.26-aarch64-apple-darwin.tar.gz"
      sha256 "ddbf5c526605bcfaa200bb244eac038917d7e1218d2d2424911514121f79714a"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.26/okfs-0.1.0-pre.26-x86_64-apple-darwin.tar.gz"
      sha256 "13abf34d17ca4550784f43a7f5d9a4057ad7cd1949c1c567e4e7bd4c3482bfc6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.26/okfs-0.1.0-pre.26-aarch64-unknown-linux-musl.tar.gz"
      sha256 "57012638d07a1eebb0cfe3dd505a5d96b7820f09f7a9d403d33c5e1f8aa0c0cc"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.26/okfs-0.1.0-pre.26-x86_64-unknown-linux-musl.tar.gz"
      sha256 "3513eac717783129f81b9eafadaa3b5c7e8e1f29c759b00d5696882b889cbecd"
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
