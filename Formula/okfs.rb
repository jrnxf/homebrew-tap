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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.7/okfs-0.1.0-pre.7-aarch64-apple-darwin.tar.gz"
      sha256 "ff028b9a3507db74ab3293eac793e0919a8da4d8627afb20c15153b65f03d981"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.7/okfs-0.1.0-pre.7-x86_64-apple-darwin.tar.gz"
      sha256 "74e40a57cb02d6f269e99c73b8cc583694fd13b665ccbc783c63043a98bad664"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.7/okfs-0.1.0-pre.7-aarch64-unknown-linux-musl.tar.gz"
      sha256 "68b4d92e8f9b06dc72d0b5cc0bb72c76714fbbe86c038ff27bad2649fbf4b05f"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.7/okfs-0.1.0-pre.7-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e8c2cc80990ca9b87e7ccee43d660f1a0d93bb88c8a8cfe70088351c56ab1bcb"
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
