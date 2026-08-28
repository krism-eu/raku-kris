#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Installing Raku desktop packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-raku-desktop.txt

# TODO: Install audited RakuOS desktop files only after test-raku-runtime.sh
# and test-kde.sh both have a meaningful implementation and pass.

dnf clean all
rm -rf /var/cache/dnf
