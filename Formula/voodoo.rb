class Voodoo < Formula
  desc "Programmable runtime for adaptive applications and operational systems"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-2.7.0.tar.gz"
  sha256 "6feaa3003fe2d292a5feb952288c8eaec444517cf41a94d2b39937423ce52f27"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  def install
    ENV["UV_TOOL_DIR"] = libexec.to_s
    system "uv", "tool", "install", "voodoo-framework==#{version}", "--python", "3.12"

    tool_bin = libexec/"voodoo-framework/bin"
    brew_python = Formula["python@3.12"].bin/"python3.12"

    %w[python python3 python3.12].each do |name|
      link = tool_bin/name
      next unless File.symlink?(link.to_s)
      FileUtils.rm_f(link)
      File.symlink(brew_python, link)
    end

    voodoo_script = tool_bin/"voodoo"
    if voodoo_script.exist?
      content = File.read(voodoo_script)
      content.sub!(%r{^#!.*$}, "#!#{tool_bin}/python3.12")
      File.write(voodoo_script, content)
      chmod("+x", voodoo_script)
    end

    # Homebrew rewrites every Mach-O it finds in the keg, including Python
    # extension modules whose @rpath install name is already correct. The
    # prebuilt Voodoo Store extension has no spare Mach-O header room for that
    # rewrite. Hide it from the relocation pass as gzip data and restore it in
    # post_install, which runs after Homebrew has finished keg relocation.
    native = Dir[libexec/"**/site-packages/voodoo_store/_native.abi3.so"].first
    odie "voodoo_store native extension not found" if native.nil?
    system "gzip", "-f", native

    # Existing compatibility workaround for jiter's Mach-O wheel.
    rm_rf Dir.glob(libexec/"**/site-packages/jiter/*.so")

    bin.install_symlink tool_bin/"voodoo"
  end

  def post_install
    native_gz = Dir[libexec/"**/site-packages/voodoo_store/_native.abi3.so.gz"].first
    return if native_gz.nil?

    system "gzip", "-d", native_gz
  end

  test do
    assert_match "Voodoo Framework CLI", shell_output("#{bin}/voodoo --help")
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import voodoo_store"
  end
end
