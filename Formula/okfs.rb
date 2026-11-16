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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.17/okfs-0.1.0-pre.17-aarch64-apple-darwin.tar.gz"
      sha256 "d9b06a2d96f3890a409f34c809c2902467a6a860cd0c2c0c69ead7598b1aae51"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.17/okfs-0.1.0-pre.17-x86_64-apple-darwin.tar.gz"
      sha256 "32929b7d543f08eaed19581ee29cee6e3d97491145608fd317ec1218504b600f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.17/okfs-0.1.0-pre.17-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4406717524314aa46bd8238151359f6235f98fbd011d920d48ca1ada24c62a63"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.17/okfs-0.1.0-pre.17-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f760e3884ea20f0967a2b5214fb74385bb8a5cea2fce9f684827bf2b71692ba5"
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
