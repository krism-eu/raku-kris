#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Running static bootc validation"

# Static checks that do not require a running systemd.
test -d /sysroot
test -x /usr/bin/bootc

# Check that essential unit files exist and are syntactically valid.
if compgen -G "/usr/lib/systemd/system/*.service" >/dev/null 2>&1; then
  for unit in /usr/lib/systemd/system/*.service; do
    systemd-analyze verify "$unit" 2>/dev/null || {
      log_error "Invalid unit file: $unit"
      exit 1
    }
  done
fi

# dnf5.real is not asserted yet: it becomes mandatory only when the genuine
# Raku runtime is added in a later committed change.

log_info "Static validation passed"
