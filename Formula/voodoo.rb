class Voodoo < Formula
  desc "Programmable runtime for adaptive applications and operational systems"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-2.7.0.tar.gz"
  sha256 "6feaa3003fe2d292a5feb952288c8eaec444517cf41a94d2b39937423ce52f27"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  # Voodoo Store ships a prebuilt Mach-O Python extension whose install name is
  # intentionally @rpath-based. Homebrew's generic post-install dylib relocation
  # cannot expand its load-command header, so leave this extension untouched.
  skip_clean "libexec/voodoo-framework/lib/python3.12/site-packages/voodoo_store/_native.abi3.so"

  def install
    # Use uv tool install — uv manages its own Python for the install step
    # (avoids pip's truststore bug and Homebrew's broken platform.mac_ver()
    # on macOS Tahoe 26.x). After install, rewrite shebangs to use Homebrew's Python.
    ENV["UV_TOOL_DIR"] = libexec.to_s
    # Pin the exact version so Homebrew always installs the formula version.
    system "uv", "tool", "install", "voodoo-framework==#{version}", "--python", "3.12"

    tool_bin = libexec/"voodoo-framework/bin"
    brew_python = Formula["python@3.12"].bin/"python3.12"

    # Replace ALL python symlinks (including broken ones) with Homebrew Python.
    %w[python python3 python3.12].each do |name|
      link = tool_bin/name
      next unless File.symlink?(link.to_s)
      FileUtils.rm_f(link)
      File.symlink(brew_python, link)
    end

    # Rewrite shebang in the voodoo script.
    voodoo_script = tool_bin/"voodoo"
    if voodoo_script.exist?
      content = File.read(voodoo_script)
      content.sub!(%r{^#!.*$}, "#!#{tool_bin}/python3.12")
      File.write(voodoo_script, content)
      chmod("+x", voodoo_script)
    end

    # Existing compatibility workaround for jiter's Mach-O wheel.
    rm_rf Dir.glob(libexec/"**/site-packages/jiter/*.so")

    bin.install_symlink tool_bin/"voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
