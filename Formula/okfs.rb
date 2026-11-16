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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.18/okfs-0.1.0-pre.18-aarch64-apple-darwin.tar.gz"
      sha256 "2a4b2edc57451afed206b237a35770c7ecd9db03df47fc8402483d00136621ce"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.18/okfs-0.1.0-pre.18-x86_64-apple-darwin.tar.gz"
      sha256 "b1e77bbd0dc03a60c0858176c3bde93d9631c4cb9aa8a5b923410b0325f4b8de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.18/okfs-0.1.0-pre.18-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bf5673191eba046b98caa167c7848c68dac078d57100b2af8c2f9bae939da733"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.18/okfs-0.1.0-pre.18-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e8cedfb5b56858b7c8dc21c08a2e641426b48d159235f595a2650f59e03df407"
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
