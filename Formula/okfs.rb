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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.23/okfs-0.1.0-pre.23-aarch64-apple-darwin.tar.gz"
      sha256 "2b49e259f38179890bdbcf15ce5be54af97ff125e014c671477c0ab16e715b58"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.23/okfs-0.1.0-pre.23-x86_64-apple-darwin.tar.gz"
      sha256 "0708c61bea9612935e550fddd6013dc87b5f73588f06223b6c8128900cee6e81"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.23/okfs-0.1.0-pre.23-aarch64-unknown-linux-musl.tar.gz"
      sha256 "00e003478dc231d3a076a8e585e1d987b40c10dced2d619fe0f35c2256756846"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.23/okfs-0.1.0-pre.23-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a438d713b6b9ad00d6687f1bb7629ffe33794ee62eac77933ea908e9ef49c2a2"
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
