class FireflyPreimporter < Formula
  desc "Transaction statement preprocessor for Firefly III / FiDI"
  url "https://github.com/hgonzale/firefly-preimporter/releases/download/v0.5.5/firefly_preimporter-0.5.5.tar.gz"
  sha256 "7caa1566dbbbf686ad6d4020fcd943073f6bbbf4729b4e4e082e3ac629fb6ad2"
  version "0.5.5"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec.to_s
    system "uv", "sync", "--frozen", "--no-dev", "--no-editable",
           "--python", Formula["python@3.13"].opt_bin/"python3.13"
    bin.install_symlink (libexec/"bin").children.select(&:file?).reject { |f|
      f.basename.to_s.start_with?("python")
    }
    system bin/"firefly-preimporter", "--version"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firefly-preimporter --version")
  end
end
