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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.12/okfs-0.1.0-pre.12-aarch64-apple-darwin.tar.gz"
      sha256 "a7fe51f6bfae5fbecb9b47a68a9aa46e79484a0b7dead7e653a8834852d627ec"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.12/okfs-0.1.0-pre.12-x86_64-apple-darwin.tar.gz"
      sha256 "2c342f2e7f7302087642d93425e420446da28d7ed4bb49acd400677eab239ec6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.12/okfs-0.1.0-pre.12-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d6a9e9903fc613e530ad30de6919c00eda5aef72bd765048e0e030a0d78dea58"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.12/okfs-0.1.0-pre.12-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f27846a24e0f25b49a0fa5e335c0603a174f3374dcd777ef21a25c0c056b5982"
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
