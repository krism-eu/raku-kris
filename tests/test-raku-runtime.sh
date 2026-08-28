#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Testing Raku runtime"

# CRITICAL: dnf5.real MUST be available after runtime phase
if ! command -v dnf5.real >/dev/null 2>&1; then
    log_error "dnf5.real not found — RakuOS runtime phase failed to provide it"
    exit 1
fi

# Verify dnf5.real is executable and returns version
if ! dnf5.real --version >/dev/null 2>&1; then
    log_error "dnf5.real --version failed — wrapper may be broken"
    exit 1
fi

log_info "dnf5.real is available and functional"

# Check that RakuOS CLI is available (optional at this stage)
if command -v rakuos >/dev/null 2>&1; then
    log_info "rakuos CLI is available"
else
    log_info "rakuos CLI not yet available (expected in early scaffold)"
fi

echo "Test Raku runtime: [PASS]"
