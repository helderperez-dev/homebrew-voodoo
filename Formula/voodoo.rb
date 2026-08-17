class Voodoo < Formula
  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.1.0.tar.gz"
  sha256 "24297f7c6cfb8e8d51bf4e114e9e337641b37904b46d50bb4ec67b41ced39d29"
  license "MIT"

  depends_on "uv"

  def install
    # Use uv tool install with a custom tool dir — uv manages its own Python,
    # avoiding both pip's truststore bug and Homebrew's broken platform.mac_ver()
    # on macOS Tahoe (26.x).
    ENV["UV_TOOL_DIR"] = libexec.to_s
    system "uv", "tool", "install", "voodoo-framework", "--python", "3.12"
    bin.install_symlink libexec/"voodoo-framework/bin/voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
