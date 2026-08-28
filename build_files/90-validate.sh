#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Running static bootc validation"

# Static checks that do not require a running systemd.
test -d /sysroot
test -x /usr/bin/bootc

# CRITICAL: Verify dnf5.real is available after runtime phase
if ! command -v dnf5.real >/dev/null 2>&1; then
    log_error "dnf5.real not found in validated image"
    exit 1
fi

log_info "dnf5.real is present in image"

# Check that essential unit files exist and are syntactically valid.
if compgen -G "/usr/lib/systemd/system/*.service" >/dev/null 2>&1; then
    for unit in /usr/lib/systemd/system/*.service; do
        systemd-analyze verify "$unit" 2>/dev/null || {
            log_error "Invalid unit file: $unit"
            exit 1
        }
    done
    log_info "All systemd unit files are valid"
else
    log_info "No systemd unit files to validate"
fi

# Verify RakuOS CLI is available
if command -v rakuos >/dev/null 2>&1; then
    log_info "rakuos CLI is available"
else
    log_info "rakuos CLI not available (may be added in desktop phase)"
fi

log_info "Static validation passed"
