#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

if [[ -f /usr/lib/raku-kris/config/gates.sh ]]; then
    source /usr/lib/raku-kris/config/gates.sh
fi

log_info "Testing Raku runtime repository"
test -f /etc/yum.repos.d/rakuos.repo

echo "Test Raku runtime: [PASS]"
