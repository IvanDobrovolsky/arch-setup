#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Starting arch-setup..."

"$SCRIPT_DIR/scripts/debloat.sh"

echo "==> Done!"
