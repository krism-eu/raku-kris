#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck source=/dev/null
source /usr/lib/raku-kris/build/lib.sh

# Scaffold checkpoint. Add checks for the Software Center and RakuOS desktop
# integration only after their package names and backend contract are verified.

echo "Test Raku desktop: [PASS] (scaffold)"
