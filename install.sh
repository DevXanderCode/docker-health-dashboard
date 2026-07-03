#!/usr/bin/env bash
#
# One-line installer for dhealth.
#
#   curl -fsSL https://raw.githubusercontent.com/DevXanderCode/docker-health-dashboard/main/install.sh | bash
#
# Downloads a released `dhealth` build from GitHub Releases, verifies its
# SHA-256 checksum against the release's checksums.txt, and installs it onto
# PATH. Never installs anything that fails checksum verification.
#
# Env vars:
#   DHEALTH_VERSION      Pin to a specific release tag, e.g. "v1.2.0".
#                         Defaults to the latest release.
#   DHEALTH_INSTALL_DIR   Force the install directory instead of auto-detecting.

set -euo pipefail
IFS=$'\n\t'

REPO="DevXanderCode/docker-health-dashboard"
BINARY="dhealth"
VERSION="${DHEALTH_VERSION:-latest}"

log()  { printf '==> %s\n' "$*"; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

# ------------------------------------------------------------------------------
# Resolve download URLs.
#
# GitHub serves a stable, unauthenticated redirect for the newest release at
# /releases/latest/download/<asset> — no API call (and no rate limit) needed.
# Pinning to a specific tag uses the versioned form instead.
# ------------------------------------------------------------------------------
if [[ "$VERSION" == "latest" ]]; then
    base_url="https://github.com/${REPO}/releases/latest/download"
else
    base_url="https://github.com/${REPO}/releases/download/${VERSION}"
fi

bin_url="${base_url}/${BINARY}"
checksums_url="${base_url}/checksums.txt"

# ------------------------------------------------------------------------------
# Download helper: prefer curl, fall back to wget so the installer works on
# any box that has either (both are near-universal on Linux/macOS).
# ------------------------------------------------------------------------------
fetch() {
    local url="$1" out="$2"
    if command -v curl &>/dev/null; then
        curl -fsSL "$url" -o "$out"
    elif command -v wget &>/dev/null; then
        wget -q "$url" -O "$out"
    else
        die "neither curl nor wget is available; install one and retry."
    fi
}

# ------------------------------------------------------------------------------
# Checksum helper: GNU coreutils ships sha256sum (Linux); macOS/BSD ships
# shasum instead. Try both so the same script verifies on either OS.
# ------------------------------------------------------------------------------
sha256_of() {
    local file="$1"
    if command -v sha256sum &>/dev/null; then
        sha256sum "$file" | awk '{print $1}'
    elif command -v shasum &>/dev/null; then
        shasum -a 256 "$file" | awk '{print $1}'
    else
        die "neither sha256sum nor shasum is available; cannot verify the download."
    fi
}

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

log "Downloading ${BINARY} (${VERSION})..."
fetch "$bin_url" "${workdir}/${BINARY}" \
    || die "download failed: ${bin_url} (does this release exist yet?)"

log "Downloading checksums..."
fetch "$checksums_url" "${workdir}/checksums.txt" \
    || die "download failed: ${checksums_url}"

log "Verifying checksum..."
expected=$(awk -v f="$BINARY" '$2 == f { print $1 }' "${workdir}/checksums.txt")
[[ -n "$expected" ]] || die "no checksum entry for '${BINARY}' in checksums.txt"

actual=$(sha256_of "${workdir}/${BINARY}")
[[ "$expected" == "$actual" ]] \
    || die "checksum mismatch — expected ${expected}, got ${actual}. Refusing to install a corrupted/tampered download."

chmod +x "${workdir}/${BINARY}"

# ------------------------------------------------------------------------------
# Pick an install directory. We never invoke sudo automatically — if
# /usr/local/bin isn't writable we fall back to a per-user directory instead
# of silently elevating privileges.
# ------------------------------------------------------------------------------
if [[ -n "${DHEALTH_INSTALL_DIR:-}" ]]; then
    install_dir="$DHEALTH_INSTALL_DIR"
elif [[ -w "/usr/local/bin" ]]; then
    install_dir="/usr/local/bin"
else
    install_dir="${HOME}/.local/bin"
fi

mkdir -p "$install_dir"
mv "${workdir}/${BINARY}" "${install_dir}/${BINARY}"

log "Installed ${BINARY} to ${install_dir}/${BINARY}"

# ------------------------------------------------------------------------------
# Warn (don't silently fail) if the install dir isn't on PATH yet.
# ------------------------------------------------------------------------------
case ":${PATH}:" in
    *":${install_dir}:"*) ;;
    *)
        log "NOTE: ${install_dir} is not on your PATH."
        log "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        log "  export PATH=\"${install_dir}:\$PATH\""
        ;;
esac

log "Done. Try:  ${BINARY} -v"
