class Rally < Formula
  desc "Local review loop for HTML files that coding agents write"
  homepage "https://github.com/jrnxf/rally"
  version "0.3.0-pre.1"

  on_macos do
    on_arm do
      url "https://github.com/jrnxf/rally/releases/download/v#{version}/rally-#{version}-darwin-arm64.tar.gz"
      sha256 "54e600f57e3d15b9a6d6bc80b798cc21cbfbf21d92e8752d36780748178e01b8"
    end
    on_intel do
      url "https://github.com/jrnxf/rally/releases/download/v#{version}/rally-#{version}-darwin-x64.tar.gz"
      sha256 "5775692e33195116d22735be30852babca1f43ed9de6be6751b525533ba08a1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jrnxf/rally/releases/download/v#{version}/rally-#{version}-linux-arm64.tar.gz"
      sha256 "e18e865fa3336515051a0ce46b5d8a9e14a3c8cf7f53f55d7596aee829d59207"
    end
    on_intel do
      url "https://github.com/jrnxf/rally/releases/download/v#{version}/rally-#{version}-linux-x64.tar.gz"
      sha256 "43b8224f0e998697be717414c7da63e64cd16e18d135c2892f4ef2e4d75c41a9"
    end
  end

  def install
    bin.install "rally"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rally --version")
  end
end
