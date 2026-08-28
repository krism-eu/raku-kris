#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing Raku desktop packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-raku-desktop.txt

# Install RakuOS desktop integration files
# This includes Software Center, welcome app, and desktop configuration

log_info "Installing RakuOS desktop integration"

# Copy desktop files if they exist
if [[ -d /usr/lib/raku-kris/files/usr/share/applications ]]; then
    cp -r /usr/lib/raku-kris/files/usr/share/applications/* /usr/share/applications/ 2>/dev/null || true
fi

if [[ -d /usr/lib/raku-kris/files/usr/share/icons ]]; then
    cp -r /usr/lib/raku-kris/files/usr/share/icons/* /usr/share/icons/ 2>/dev/null || true
fi

# Copy configuration files
if [[ -d /usr/lib/raku-kris/files/etc ]]; then
    cp -r /usr/lib/raku-kris/files/etc/* /etc/ 2>/dev/null || true
fi

log_info "RakuOS desktop integration installed"

dnf clean all
rm -rf /var/cache/dnf
