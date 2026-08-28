#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Running static bootc validation"

test -d /sysroot
test -x /usr/bin/bootc
log_info "bootc is present and /sysroot exists"

if compgen -G "/usr/lib/systemd/system/rakuos-*.service" >/dev/null 2>&1; then
    for unit in /usr/lib/systemd/system/rakuos-*.service; do
        systemd-analyze verify "$unit" 2>/dev/null || {
            log_error "Invalid unit file: $unit"
            exit 1
        }
    done
    log_info "All RakuOS systemd unit files are valid"
else
    log_info "No RakuOS systemd unit files to validate"
fi

if ! command -v rakuos >/dev/null 2>&1; then
    log_error "rakuos CLI not available"
    exit 1
fi
log_info "rakuos CLI is available"

if ! rpm -q rakuos-release >/dev/null 2>&1; then
    log_error "rakuos-release not installed"
    exit 1
fi
log_info "rakuos-release is installed"

log_info "Static validation passed"
