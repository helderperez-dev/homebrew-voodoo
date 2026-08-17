class Voodoo < Formula
  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.1.0.tar.gz"
  sha256 "24297f7c6cfb8e8d51bf4e114e9e337641b37904b46d50bb4ec67b41ced39d29"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  # Skip dylib fixup — vendored Python .so files lack header padding
  skip_clean libexec

  def install
    # Use uv instead of pip to avoid truststore bug on macOS Tahoe
    system "uv", "venv", libexec, "--python", "3.12"
    system "uv", "pip", "install", "--python", libexec/"bin/python", "voodoo-framework"
    bin.install_symlink libexec/"bin/voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
