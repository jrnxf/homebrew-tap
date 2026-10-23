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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.1/okfs-0.1.0-pre.1-aarch64-apple-darwin.tar.gz"
      sha256 "1695da357d8954f605f2d0030c4dae441d9863231e367ee6f188278b9259f68d"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.1/okfs-0.1.0-pre.1-x86_64-apple-darwin.tar.gz"
      sha256 "0b0b04f42e380f38b76361c2fceaf383fc4f3f0ec64d40ede41b0b8a5ef4f07c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.1/okfs-0.1.0-pre.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1163a5d365efb9ab1a8bd191426aa509cf6a53d1b7118d1433dbec4fe6eb6e85"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.1/okfs-0.1.0-pre.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a8bbd2f5f422726778634467567096e147dea46d2e83428d3686bc1da150db89"
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
