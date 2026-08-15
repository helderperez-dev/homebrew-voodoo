class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.18.tar.gz"
  sha256 "2db0976733592102f03c7ad9c7cd7ca7073660dd7b853844d3d3a3da990b87f9"
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