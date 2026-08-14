class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.7.tar.gz"
  sha256 "ec77365cad15e0e347a0335344f52a3f876c61f8b4c08f9a7cf6977ed71586dc"
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