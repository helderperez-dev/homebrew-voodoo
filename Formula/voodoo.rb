class Voodoo < Formula
  include Language::Python::Virtualenv

  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.0.21.tar.gz"
  sha256 "759a573f2f7e19e693ef495f2929d540e5f11847fd412b30f145ba6952a8b791"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
