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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.3/okfs-0.1.0-pre.3-aarch64-apple-darwin.tar.gz"
      sha256 "237deb0081e25a23e462c70483c1de796b1bc8d3510aa5231279199cdaf652ef"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.3/okfs-0.1.0-pre.3-x86_64-apple-darwin.tar.gz"
      sha256 "8c335d748158cf45f2dd0398eafe62233f0f03f7023e449b49f2ae17e0e43a32"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.3/okfs-0.1.0-pre.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0f5ffc32b9b7ecb40d0050bd63c2f4a87d044bd1b62b8f521c6c6b6fd81bffc8"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.3/okfs-0.1.0-pre.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c09cfa680b07d9ca7a91f578b6caf1cb50ae88b49ba61fe21620a33927bc165e"
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
