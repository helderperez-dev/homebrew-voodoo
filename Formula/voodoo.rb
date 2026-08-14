class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.8.tar.gz"
  sha256 "72f93d80dd85a6d38373751984cb81716dada63c2c3728bb42f44e3ab63558a4"
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