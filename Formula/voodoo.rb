class Voodoo < Formula
  desc "Fast, Animated, AI-Powered Python Web Framework"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.1.0.tar.gz"
  sha256 "24297f7c6cfb8e8d51bf4e114e9e337641b37904b46d50bb4ec67b41ced39d29"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  def install
    # Use uv instead of pip to avoid truststore bug on macOS Tahoe.
    # Use --system-site-packages so uv uses the Homebrew Python, not a temp download.
    system "uv", "venv", libexec, "--python", Formula["python@3.12"].opt_bin/"python3", "--system-site-packages"
    system "uv", "pip", "install", "--python", libexec/"bin/python", "voodoo-framework"

    # Remove .so files whose Mach-O headers lack padding for Homebrew's dylib fixup.
    # jiter (pydantic/openai dependency) ships without -headerpad_max_install_names.
    rm_rf Dir.glob(libexec/"lib/python*/site-packages/jiter/*.so")

    bin.install_symlink libexec/"bin/voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
