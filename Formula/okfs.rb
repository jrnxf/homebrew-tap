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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.36/okfs-0.1.0-pre.36-aarch64-apple-darwin.tar.gz"
      sha256 "79ea2f9be1edc65b5ac940134b6a686964e7948b1beaaae2960e026ba7b88513"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.36/okfs-0.1.0-pre.36-x86_64-apple-darwin.tar.gz"
      sha256 "5306efa2c73d1bcfd07b30e020ae200daccd6deaa2da68aa2ede95bc08bc058c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.36/okfs-0.1.0-pre.36-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b19fdb031beaf7d2b127054d7ea704b7b3959c238407d134b884b382fe3a100b"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.36/okfs-0.1.0-pre.36-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cd26b699a788d29335b7684becd5aa12e0890d678abcb34daa0dcf5151a930cc"
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
