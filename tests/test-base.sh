#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

log_info "Testing base system"

test -d /sysroot
test -x /usr/bin/bootc
bootc --version

# Explicitly assert dnf5 availability for build-time consistency.
if command -v dnf5 >/dev/null 2>&1; then
  dnf5 --version
else
  log_error "dnf5 not found in base image"
  exit 1
fi

echo "Test base system: [PASS]"
