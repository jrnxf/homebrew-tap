class Vxr < Formula
  desc "Fast voxel scene editor for macOS, with an MCP server for coding agents"
  homepage "https://github.com/jrnxf/vxr"
  url "https://github.com/jrnxf/vxr/releases/download/v0.1.0-pre.8/vxr-0.1.0-pre.8-universal-apple-darwin.tar.gz"
  sha256 "db4c53fe9e538a33654fc5c0836e55e4dc0b530a4b1ce7fb4eb0b9acba9eff41"

  head do
    url "https://github.com/jrnxf/vxr.git", branch: "main"

    depends_on "rust" => :build
  end

  depends_on macos: :ventura

  def install
    # crates/vxr-app/bundle builds vxr.app for this Mac, with its fonts and icon.
    system "crates/vxr-app/bundle", buildpath if build.head?
    # A release is one archive holding vxr.app, whose binary is universal, for Apple silicon and
    # Intel. The binary is the editor, `vxr mcp` and `vxr setup` in one, and finds its fonts in
    # the app, so bin/vxr links into it.
    prefix.install "vxr.app"
    bin.install_symlink prefix/"vxr.app/Contents/MacOS/vxr"
    # The notices for every Rust crate compiled in, which must ship with every copy. brew keeps
    # README.md on its own, but not this.
    prefix.install "THIRD_PARTY.md" unless build.head?
  end

  def caveats
    <<~EOS
      Run `vxr` to open the editor, or `vxr scene.vox` to open a file.
      Run `vxr setup app` to open it from Spotlight too (it adds ~/Applications/vxr.app).
      Run `vxr setup claude` (or codex) to let that agent edit the .vox files in ~/vxr,
      and the scene open in the editor.
    EOS
  end

  test do
    assert_match(/vxr \d+\.\d+\.\d+/, shell_output("#{bin}/vxr --version"))
    assert_match "--root <dir>", shell_output("#{bin}/vxr mcp --help")
  end
end
