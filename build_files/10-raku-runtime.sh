#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing Raku runtime packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-raku-runtime.txt

# CRITICAL: This phase MUST provide dnf5.real as a real binary, not a symlink.
# The dnf5.real binary is what allows RakuOS to manage the persistent overlay
# separately from the immutable bootc base.
#
# Implementation options:
# 1. Build dnf5.real from RakuOS source (preferred for production)
# 2. Package dnf5.real as part of rakuos-runtime RPM
# 3. Provide dnf5.real as a wrapper that configures dnf5 for overlay installs
#
# For this scaffold, we create a minimal dnf5.real wrapper that configures
# dnf5 to install into the overlay root. This is NOT production-ready but
# demonstrates the architecture.

log_info "Creating dnf5.real wrapper for overlay management"

mkdir -p /usr/bin /usr/libexec/rakuos /usr/lib/systemd/system

# Create dnf5.real as a wrapper that configures dnf5 for overlay installs
# This is a TEMPORARY scaffold implementation. Replace with real dnf5.real binary.
cat > /usr/bin/dnf5.real << 'DNF5_REAL'
#!/usr/bin/env bash
set -Eeuo pipefail

# dnf5.real - RakuOS overlay package manager wrapper
# This is a TEMPORARY scaffold. Production builds should use the real dnf5.real binary.

OVERLAY_MOUNT="/var/rakuos-overlay"

# If overlay is mounted, install into it
if [[ -d "$OVERLAY_MOUNT" ]] && mountpoint -q "$OVERLAY_MOUNT" 2>/dev/null; then
    # Install into overlay root
    exec dnf5 --installroot="$OVERLAY_MOUNT" "$@"
else
    # Fallback: install to system root (this will fail on immutable bootc)
    # This path should not be reached in a properly configured system
    echo "WARNING: Overlay not mounted. Installing to system root." >&2
    exec dnf5 "$@"
fi
DNF5_REAL

chmod 0755 /usr/bin/dnf5.real

# Verify dnf5.real is callable
if ! /usr/bin/dnf5.real --version >/dev/null 2>&1; then
    log_error "dnf5.real wrapper failed to execute"
    exit 1
fi

log_info "dnf5.real wrapper created and validated"

# Copy RakuOS runtime files into the image
log_info "Installing RakuOS runtime files"

# Copy CLI and libexec scripts
if [[ -f /usr/lib/raku-kris/files/usr/bin/rakuos ]]; then
    cp /usr/lib/raku-kris/files/usr/bin/rakuos /usr/bin/
fi

if [[ -d /usr/lib/raku-kris/files/usr/libexec/rakuos ]]; then
    cp /usr/lib/raku-kris/files/usr/libexec/rakuos/*.sh /usr/libexec/rakuos/ 2>/dev/null || true
fi

if [[ -d /usr/lib/raku-kris/files/usr/lib/systemd/system ]]; then
    cp /usr/lib/raku-kris/files/usr/lib/systemd/system/*.service /usr/lib/systemd/system/ 2>/dev/null || true
    cp /usr/lib/raku-kris/files/usr/lib/systemd/system/*.timer /usr/lib/systemd/system/ 2>/dev/null || true
fi

# Set executable permissions
if [[ -f /usr/bin/rakuos ]]; then
    chmod 0755 /usr/bin/rakuos
fi

if [[ -d /usr/libexec/rakuos ]]; then
    chmod 0755 /usr/libexec/rakuos/*.sh 2>/dev/null || true
fi

# Copy repository configuration
mkdir -p /etc/yum.repos.d
if [[ -f /usr/lib/raku-kris/files/etc/yum.repos.d/rakuos.repo ]]; then
    cp /usr/lib/raku-kris/files/etc/yum.repos.d/rakuos.repo /etc/yum.repos.d/
fi

log_info "RakuOS runtime files installed"

dnf clean all
rm -rf /var/cache/dnf
