class FireflyPreimporter < Formula
  desc "Transaction statement preprocessor for Firefly III / FiDI"
  url "https://github.com/hgonzale/firefly-preimporter/releases/download/v0.5.11/firefly_preimporter-0.5.11.tar.gz"
  sha256 "99acbe7db1f55d2af4a0e76cff1950fd683350835cb253e8d574f9fed461e5d6"
  version "0.5.11"

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
