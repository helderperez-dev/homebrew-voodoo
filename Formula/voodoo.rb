class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.23.tar.gz"
  sha256 "2a6b4f7e947b323ce99240e2592f6f4022a910245e1fd4b3afd9e68ec640b743"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
