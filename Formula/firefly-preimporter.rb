class FireflyPreimporter < Formula
  desc "Transaction statement preprocessor for Firefly III / FiDI"
  url "https://github.com/hgonzale/firefly-preimporter/releases/download/v0.5.7/firefly_preimporter-0.5.7.tar.gz"
  sha256 "4dce606c336479d3bc7eb50e34cfd06b2eea928afc3857e781880ae1e88e97fd"
  version "0.5.7"

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
