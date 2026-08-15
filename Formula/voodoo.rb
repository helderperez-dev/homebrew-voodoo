class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.19.tar.gz"
  sha256 "e38700179a3001cdf06912dd7579388d8c5c6ea4eabbd3487225da81d1fad1d6"
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