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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.8/okfs-0.1.0-pre.8-aarch64-apple-darwin.tar.gz"
      sha256 "f93832a290a6c13501c5c42817861574ab147b561ca7f2f0271beb396c693567"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.8/okfs-0.1.0-pre.8-x86_64-apple-darwin.tar.gz"
      sha256 "583b8b57ace227f83e8d36bcae5e6f489ee325e5b72c1e63783a64f29e31be60"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.8/okfs-0.1.0-pre.8-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3a2fd55852d5336a1ee8719d73a0c004bb23d164f1d414cb249c111395348458"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.8/okfs-0.1.0-pre.8-x86_64-unknown-linux-musl.tar.gz"
      sha256 "98077cea8f69ff108e28a9cbea2c77f03aa5c4c92db62ef64e5bf48a768c2ab8"
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
