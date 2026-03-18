#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Starting arch-setup..."

"$SCRIPT_DIR/scripts/debloat.sh"
"$SCRIPT_DIR/scripts/install.sh"
"$SCRIPT_DIR/scripts/shell.sh"
"$SCRIPT_DIR/scripts/nvim.sh"

echo "==> Done!"
