class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/92/a7/763e98ffdcfaa911350e9db86f586aeb9ec3b26fa4b21ffb2fa88e1527c1/voodoo_framework-1.0.0.tar.gz"
  sha256 "d02c54b68991486b9a3d99d6cb32fa02d5e3588c3b20bc5bfaffea5bab2bb4a4"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Use Homebrew's built-in Python virtualenv helper instead of manual venv
    virtualenv_install_with_resources
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end