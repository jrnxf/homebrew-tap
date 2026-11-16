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
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.22/okfs-0.1.0-pre.22-aarch64-apple-darwin.tar.gz"
      sha256 "e2ab227d16ee9d7437a5cb2f99da0abbe252de15af9928513413686d153ecd9b"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.22/okfs-0.1.0-pre.22-x86_64-apple-darwin.tar.gz"
      sha256 "e22bc9bcec456eac7d2cf1d178b9fb22ddc9063d38352ba7a737eb960105f11d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.22/okfs-0.1.0-pre.22-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1d3549c18f59ba10c38c7c797504dae152f081cc3a2824a3bbe720f1c3dba309"
    end
    on_intel do
      url "https://github.com/jrnxf/okfs/releases/download/v0.1.0-pre.22/okfs-0.1.0-pre.22-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6f08b73e5316f11ba6822e618493863e22a7d69b0b37d31acdeab7ba8df8b8f3"
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
