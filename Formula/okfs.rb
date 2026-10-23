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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.4/okfs-0.1.0-pre.4-aarch64-apple-darwin.tar.gz"
      sha256 "15df9986b839ccd916481d193bc903f666b1a5fd2e0ef06e5998945597d49821"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.4/okfs-0.1.0-pre.4-x86_64-apple-darwin.tar.gz"
      sha256 "ee5cdce953a74d25a19e80872fe01b5845663d08ee2246f8be03ba2f4fa29b96"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.4/okfs-0.1.0-pre.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f8cf06fb7eef32b56ff3e5686a198c5b760764e6bfd13fbbbdb867d6991a3f23"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.4/okfs-0.1.0-pre.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "06ddb60079d25cb8fec736e820bb0852a7d1b751aff198e795017805197bc64b"
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
