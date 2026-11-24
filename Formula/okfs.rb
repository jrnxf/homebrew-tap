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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.34/okfs-0.1.0-pre.34-aarch64-apple-darwin.tar.gz"
      sha256 "6d80fe822ff2d8d2b631d39cec95b0d42b9d29582f42106caaf4ca38008d8b52"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.34/okfs-0.1.0-pre.34-x86_64-apple-darwin.tar.gz"
      sha256 "bcaba98e991eb897d8affe7271e795dacff0e60e089d1d0222aaed98499a93ec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.34/okfs-0.1.0-pre.34-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3b5bec0344e254d4ce6723c90a2ca43a53636868af98cf53ba55f1a9c2f29fa7"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.34/okfs-0.1.0-pre.34-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bb3c43d1581f3dd2ffd8d7b085414b5eef68d6f8bd4761c2d8e4b124df313169"
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
