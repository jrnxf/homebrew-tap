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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.20/okfs-0.1.0-pre.20-aarch64-apple-darwin.tar.gz"
      sha256 "c0f74da3559b707d562c255067c2e46becfa1b1adc8a50110bc63672a35c4f25"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.20/okfs-0.1.0-pre.20-x86_64-apple-darwin.tar.gz"
      sha256 "9ed81e721d7f55154584f0634ad0ab3178a45129856ebc7eb27d32f387560a50"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.20/okfs-0.1.0-pre.20-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c0a1a6a16c18401f45aadff362acb7f3f5d27190b3905a3e9c9c9aed69bdd0e2"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.20/okfs-0.1.0-pre.20-x86_64-unknown-linux-musl.tar.gz"
      sha256 "819638d3a2324d24200af8396e9b324b270370fbb98f0ddd271ff7862e689c2b"
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
