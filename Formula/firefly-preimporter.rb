class FireflyPreimporter < Formula
  desc "Transaction statement preprocessor for Firefly III / FiDI"
  url "https://github.com/hgonzale/firefly-preimporter/releases/download/v0.7.1/firefly_preimporter-0.7.1.tar.gz"
  sha256 "5545921c9f5c9a31b9b38486f9d1ae7cc0b5ef921e8a4673efb71e679fadd8ca"
  version "0.7.1"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec.to_s
    system "uv", "sync", "--frozen", "--no-dev", "--no-editable",
           "--python", Formula["python@3.13"].opt_bin/"python3.13"
    # jiter's pre-built wheel uses @rpath in its Mach-O dylib ID, which
    # Homebrew tries to rewrite to an absolute path but fails because the
    # header has no padding room. Shortening to a bare name stops Homebrew
    # from attempting the rewrite; Python loads .so files by explicit path
    # so the dylib ID is unused at runtime.
    jiter_so = Pathname.glob(libexec/"lib/python3.*/site-packages/jiter/jiter*.so").first
    if jiter_so&.exist?
      system "install_name_tool", "-id", "jiter.so", jiter_so.to_s
      system "codesign", "--force", "--sign", "-", jiter_so.to_s
    end
    bin.install_symlink (libexec/"bin").children.select(&:file?).reject { |f|
      f.basename.to_s.start_with?("python")
    }
    system bin/"firefly-preimporter", "--version"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly-preimporter --version")
  end
end
