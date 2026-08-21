class Voodoo < Formula
  desc "Programmable runtime for adaptive applications and operational systems"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-1.17.1.tar.gz"
  sha256 "64b76aecc7f6ede33cde635df97caa7767a46f8f42b2ef876964f1eaa94cd961"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  def install
    # Use uv tool install — uv manages its own Python for the install step
    # (avoids pip's truststore bug and Homebrew's broken platform.mac_ver()
    # on macOS Tahoe 26.x). After install, rewrite shebangs to use Homebrew's Python.
    ENV["UV_TOOL_DIR"] = libexec.to_s
    # Pin the exact version — an unpinned  would pull
    # whatever is latest on PyPI at  time and ignore the
    # url/sha256 above, shipping stale framework code.
    system "uv", "tool", "install", "voodoo-framework==#{version}", "--python", "3.12"

    tool_bin = libexec/"voodoo-framework/bin"
    brew_python = Formula["python@3.12"].bin/"python3.12"

    # Replace ALL python symlinks (including broken ones) with Homebrew Python.
    # Use lstat to detect broken symlinks (File.exist? returns false for those).
    %w[python python3 python3.12].each do |name|
      link = tool_bin/name
      next unless File.symlink?(link.to_s)
      FileUtils.rm_f(link)
      File.symlink(brew_python, link)
    end

    # Rewrite shebang in the voodoo script
    voodoo_script = tool_bin/"voodoo"
    if voodoo_script.exist?
      content = File.read(voodoo_script)
      content.sub!(%r{^#!.*$}, "#!#{tool_bin}/python3.12")
      File.write(voodoo_script, content)
      chmod("+x", voodoo_script)
    end

    # Remove .so files whose Mach-O headers lack padding for Homebrew's dylib fixup.
    rm_rf Dir.glob(libexec/"**/site-packages/jiter/*.so")

    bin.install_symlink tool_bin/"voodoo"
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
  end
end
