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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.37/okfs-0.1.0-pre.37-aarch64-apple-darwin.tar.gz"
      sha256 "c2bf44303356cd1b5bd6301373e04f3faeacaac6f7b87320f87766c76db8855a"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.37/okfs-0.1.0-pre.37-x86_64-apple-darwin.tar.gz"
      sha256 "a08ae58779c3c2a5df11c9801e98bbaed47e8638aef64a96f41838b76abdddb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.37/okfs-0.1.0-pre.37-aarch64-unknown-linux-musl.tar.gz"
      sha256 "aff98b1db9b3855a42e3c6ca0c187e370853575c24816ac385fc91904ec89f13"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.37/okfs-0.1.0-pre.37-x86_64-unknown-linux-musl.tar.gz"
      sha256 "558cec8961ce2a9e0d6ccd261eee2afa183b941174bd5fb5f421b7e85c0e9e4e"
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
