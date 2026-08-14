class Voodoo < Formula
  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/92/a7/763e98ffdcfaa911350e9db86f586aeb9ec3b26fa4b21ffb2fa88e1527c1/voodoo_framework-1.0.0.tar.gz"
  sha256 "d02c54b68991486b9a3d99d6cb32fa02d5e3588c3b20bc5bfaffea5bab2bb4a4"
  license "MIT"

  depends_on "python@3.12"

  def install
    venv = libexec/"venv"
    system "python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--upgrade", "pip"
    system venv/"bin/pip", "install", "-v", "--no-binary", ":all:", "--ignore-installed", buildpath
    bin.install_symlink libexec/"venv/bin/voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end