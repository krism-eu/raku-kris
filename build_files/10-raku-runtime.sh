#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Configuring RakuOS repository"

mkdir -p /etc/yum.repos.d
if [[ -f /usr/lib/raku-kris/files/etc/yum.repos.d/rakuos.repo ]]; then
    cp /usr/lib/raku-kris/files/etc/yum.repos.d/rakuos.repo /etc/yum.repos.d/
    log_info "Installed RakuOS repository configuration"
else
    log_error "RakuOS repository configuration not found in system_files/"
    exit 1
fi

dnf5 clean all
rm -rf /var/cache/dnf
