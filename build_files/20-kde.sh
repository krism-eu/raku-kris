#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing KDE packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-kde-minimal.txt

# KDE package data will be added only after the Raku runtime contract is known.

dnf clean all
rm -rf /var/cache/dnf
