#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

# This script is intentionally non-functional until the real RakuOS runtime
# files and packages are mapped from the previous attempts. It must provide
# dnf5.real itself, rather than assuming Fedora bootc Minimal already has it.

log_info "Installing Raku runtime packages from allowlist"
install_from_list /usr/lib/raku-kris/config/packages-raku-runtime.txt

# TODO: Copy audited RakuOS repositories, overlay scripts, unit files,
# tmpfiles, polkit rules, wrapper and the genuine dnf5.real provider here.
# No symlink or rename workaround is allowed.

dnf clean all
rm -rf /var/cache/dnf
