#!/usr/bin/env bash
set -Eeuo pipefail
source /usr/lib/raku-kris/build/lib.sh

log_info "Running cleanup phase"

if grep -Ev '^[[:space:]]*(#|$)' /usr/lib/raku-kris/config/packages-remove-candidates.txt | grep -q .; then
    log_error "Refusing automatic removals: audit and encode removals explicitly first."
    exit 1
fi

log_info "No packages marked for removal (audit required)"

# Pulizia fisica delle cache (nessuna invocazione dnf/dnf5 dopo rum-dnf-shim)
rm -rf /var/cache/dnf /var/cache/rum /var/lib/dnf /tmp/* /var/tmp/*

log_info "Cleanup complete"
