#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Testing RakuOS desktop integration"

for pkg in rakuos-core rakuos-rum rum-dnf-shim rakuos-release ark okular podman; do
    if ! rpm -q "$pkg" >/dev/null 2>&1; then
        log_error "Package $pkg not installed"
        exit 1
    fi
    log_info "Package $pkg installed"
done

if ! command -v rakuos >/dev/null 2>&1; then
    log_error "rakuos CLI not available"
    exit 1
fi

if ! command -v flatpak >/dev/null 2>&1; then
    log_error "flatpak not available"
    exit 1
fi

echo "Test Raku desktop: [PASS]"
