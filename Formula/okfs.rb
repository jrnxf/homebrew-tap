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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.31/okfs-0.1.0-pre.31-aarch64-apple-darwin.tar.gz"
      sha256 "9722a5fb74092dbf7cc178e4866d762cf1afe76499122913eafd7bd7772db5a2"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.31/okfs-0.1.0-pre.31-x86_64-apple-darwin.tar.gz"
      sha256 "4da3b1e6eeccdce0685b1412cf30655b38f5b8d887782c462a52791dc5128423"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.31/okfs-0.1.0-pre.31-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a233d93e8942155536c2046c1d2d1236e9566db4caf338de8440cde10f439aad"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.31/okfs-0.1.0-pre.31-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dbe2b86bada7150dd7df5a26b93a6e946ed6a847aaf3160a57865d7182e4f384"
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
