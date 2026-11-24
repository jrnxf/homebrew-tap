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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.27/okfs-0.1.0-pre.27-aarch64-apple-darwin.tar.gz"
      sha256 "18ccc2ae8fdfee112fe1938087ac8355773b90d452d1bf2352e964ba45dfb0cc"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.27/okfs-0.1.0-pre.27-x86_64-apple-darwin.tar.gz"
      sha256 "8a3e202d0945b23c5a492b8af9315c7904a92f4d0e2d9bde6d17e17b7926719b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.27/okfs-0.1.0-pre.27-aarch64-unknown-linux-musl.tar.gz"
      sha256 "fb0c06a3f6de12cd10e86dcb63cf337b687a86d02fd0631f53a25a0cb80249aa"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.27/okfs-0.1.0-pre.27-x86_64-unknown-linux-musl.tar.gz"
      sha256 "94f92f2e779de9505ac2a496f0184fed50646ed46e6ecce876009eae57689ed0"
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
