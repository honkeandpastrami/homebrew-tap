# The CLI's Homebrew formula. deploy/exchequer-cli-formula fills in 1.7.0,
# https://github.com/honkeandpastrami/exchequer/releases/download/v1.7.0/exchequer-python-1.7.0.tar.gz and db453540e715a322933a3d23a00ab977e2d4cbed6cb4f6e27a5bb6535d3e6261; each release commits the result to
# honkeandpastrami/homebrew-tap (docs/deployment.md). The tarball is the
# release's Python workspace (deploy/build-python-source).
class ExchequerCli < Formula
  desc "Command-line client for Exchequer, a household ledger"
  homepage "https://github.com/honkeandpastrami/exchequer"
  url "https://github.com/honkeandpastrami/exchequer/releases/download/v1.7.0/exchequer-python-1.7.0.tar.gz"
  version "1.7.0"
  sha256 "db453540e715a322933a3d23a00ab977e2d4cbed6cb4f6e27a5bb6535d3e6261"
  license "BSD-2-Clause"

  depends_on "uv" => :build
  depends_on "python@3.13"

  def install
    ENV["UV_PROJECT_ENVIRONMENT"] = libexec.to_s
    ENV["UV_PYTHON_DOWNLOADS"] = "never"
    # The tarball has no git history to take the version from (hatch-vcs).
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    cd "python" do
      system "uv", "sync", "--frozen", "--no-dev", "--no-editable", "--package", "exchequer-cli",
             "--python", formula_opt_bin("python@3.13")/"python3.13"
    end
    bin.install_symlink libexec/"bin/exchequer"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/exchequer --version").strip
  end
end
