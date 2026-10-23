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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.6/okfs-0.1.0-pre.6-aarch64-apple-darwin.tar.gz"
      sha256 "e6b6b7143e42f3f894896718abfcc0f9fd32210c0c4755c57b61458bba6af28a"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.6/okfs-0.1.0-pre.6-x86_64-apple-darwin.tar.gz"
      sha256 "fcf095e6afab60226fa0ef3e05035798bd16ac2b5724a4f3b62c804e6255c952"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.6/okfs-0.1.0-pre.6-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6be35ae02cecbe03dcff56be74d6b189226eb426a86c021de1f0ba4b5457b40d"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.6/okfs-0.1.0-pre.6-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a2f56be23411dd2c553d23c93d57828903d5c639b065942651f631bff5049a41"
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
