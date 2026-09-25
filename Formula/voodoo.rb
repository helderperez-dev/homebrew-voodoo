class Voodoo < Formula
  desc "Programmable runtime for adaptive applications and operational systems"
  homepage "https://github.com/helderperez-dev/voodoo"
  url "https://files.pythonhosted.org/packages/source/v/voodoo-framework/voodoo_framework-3.1.0.tar.gz"
  sha256 "5e7ad6308f2e3fff8951d70939ec5db9d64fdb7db9163054539965866bf77bfc"
  license "MIT"

  depends_on "uv"
  depends_on "python@3.12"

  def install
    ENV["UV_TOOL_DIR"] = libexec.to_s
    # --refresh-package: never trust a cached simple index for the target
    # package. Otherwise an install right after a PyPI publish can resolve
    # against a stale index entry and fail with an empty candidate set.
    system "uv", "tool", "install", "voodoo-framework==#{version}", "--python", "3.12",
           "--refresh-package", "voodoo-framework"

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

    # Homebrew rewrites every Mach-O it finds in the keg. Voodoo
    # Store's prebuilt @rpath extension is already relocatable but has
    # no spare Mach-O header room for Homebrew's longer install name.
    # Hide it as gzip data during keg relocation and restore it in
    # post_install after Homebrew's relocation pass has completed.
    native = Dir[libexec/"**/site-packages/voodoo_store/_native.abi3.so"].first
    odie "voodoo_store native extension not found" if native.nil?
    system "gzip", "-f", native

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
    system bin/"voodoo", "create", "smoke-app"
    cd testpath/"smoke-app" do
      system libexec/"voodoo-framework/bin/python3.12", "-c", <<~PY
        import runpy
        from pathlib import Path
        from starlette.testclient import TestClient
        ns = runpy.run_path('main.py', run_name='brew_smoke')
        with TestClient(ns['app']) as client:
            assert client.get('/').status_code == 200
        assert Path('.voodoo/application.vstore').exists()
      PY
    end
  end
end
