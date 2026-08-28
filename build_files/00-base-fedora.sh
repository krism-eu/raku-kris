#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

# Fedora bootc Minimal is the build root. Do not call dnf5.real here.
# Do not run a general dnf upgrade in a derived bootc image.

log_info "Installing base packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-base.txt

dnf clean all
rm -rf /var/cache/dnf
