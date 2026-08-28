#!/usr/bin/env bash
# Shared library for Raku Kris build scripts.
# shellcheck disable=SC2034  # Some helpers are intended for future use.

set -Eeuo pipefail

# Install packages from an allowlist file, ignoring comments and blank lines.
install_from_list() {
  local list=$1
  mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$list")
  ((${#packages[@]})) || return 0

  # Explicitly use dnf (Fedora's dnf5) during image construction.
  if command -v dnf5 >/dev/null 2>&1; then
    dnf5 -y install "${packages[@]}"
  else
    dnf -y install "${packages[@]}"
  fi
}

# Log helpers for consistent output.
log_info() {
  echo "[INFO] $*"
}

log_error() {
  echo "[ERROR] $*" >&2
}
