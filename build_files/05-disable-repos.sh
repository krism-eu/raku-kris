#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Disabling unnecessary repositories"

# Disabilita repo di testing e debug
dnf5 config-manager --set-disabled updates-testing 2>/dev/null || true
dnf5 config-manager --set-disabled updates-testing-debuginfo 2>/dev/null || true
dnf5 config-manager --set-disabled updates-testing-source 2>/dev/null || true
dnf5 config-manager --set-disabled fedora-debuginfo 2>/dev/null || true
dnf5 config-manager --set-disabled fedora-source 2>/dev/null || true
dnf5 config-manager --set-disabled rpmfusion-free-debuginfo 2>/dev/null || true
dnf5 config-manager --set-disabled rpmfusion-free-source 2>/dev/null || true
dnf5 config-manager --set-disabled rpmfusion-nonfree-debuginfo 2>/dev/null || true
dnf5 config-manager --set-disabled rpmfusion-nonfree-source 2>/dev/null || true

log_info "Repositories configured"
