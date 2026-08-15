class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.22.tar.gz"
  sha256 "022c5e48c2d013f6e301fa9f44799d73f5cfca0cbc2320409e3b50a891364c57"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
