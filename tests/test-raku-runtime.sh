#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

if [[ -f /usr/lib/raku-kris/config/gates.sh ]]; then
    source /usr/lib/raku-kris/config/gates.sh
fi

log_info "Testing Raku runtime repository"

if [[ ! -f /etc/yum.repos.d/rakuos.repo ]]; then
    log_error "RakuOS repository file missing"
    exit 1
fi

# Verifica che dnf5 veda il repo e possa risolvere almeno un pacchetto
if ! dnf5 repolist | grep -qi rakuos; then
    log_error "RakuOS repository not visible to dnf5"
    exit 1
fi

if ! dnf5 repoquery --available rakuos-core >/dev/null 2>&1; then
    log_error "rakuos-core not resolvable from RakuOS repo"
    exit 1
fi

log_info "RakuOS repository configured and reachable"
echo "Test Raku runtime: [PASS]"
