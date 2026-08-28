#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Running cleanup phase"

# Cleanup is a no-op by design until every candidate has a dependency review.
# Never use 'dnf remove ... || true': it hides broken assumptions.

if grep -Ev '^[[:space:]]*(#|$)' /usr/lib/raku-kris/config/packages-remove-candidates.txt | grep -q .; then
    log_error "Refusing automatic removals: audit and encode removals explicitly first."
    exit 1
fi

log_info "No packages marked for removal (audit required)"

dnf clean all
rm -rf /var/cache/dnf /tmp/* /var/tmp/*

log_info "Cleanup complete"
