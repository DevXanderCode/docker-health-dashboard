# Homebrew formula for dhealth.
#
# This file lives here for convenience, but Homebrew formulas are normally
# served from a dedicated "tap" repository so `brew install` can find them by
# a short name. To actually publish this:
#
#   1. Tag and push a release here first (e.g. `git tag v1.0.0 && git push
#      --tags`) — the release workflow (.github/workflows/release.yml) then
#      publishes the release this formula points at.
#   2. Compute the tarball's checksum and paste it into `sha256` below:
#        curl -sL https://github.com/DevXanderCode/docker-health-dashboard/archive/refs/tags/v1.0.0.tar.gz \
#          | shasum -a 256
#   3. Create a new GitHub repo named exactly "homebrew-dhealth" (the
#      "homebrew-" prefix is what lets the short `brew tap` form below work)
#      and copy this file into it at Formula/dhealth.rb.
#
# Once published, users install with:
#   brew tap DevXanderCode/dhealth
#   brew install dhealth

class Dhealth < Formula
  desc "Terminal dashboard for Docker container health and host resources"
  homepage "https://github.com/DevXanderCode/docker-health-dashboard"
  url "https://github.com/DevXanderCode/docker-health-dashboard/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256" # see step 2 above
  license "MIT"

  def install
    bin.install "dhealth"
  end

  def caveats
    <<~EOS
      dhealth requires Docker to be installed and its daemon reachable.

      On macOS, the host memory summary also needs a GNU-compatible `free`,
      which this formula does not pull in automatically:
        brew install inetutils
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dhealth -v")
  end
end
