#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/../dotfiles"

echo "==> Configuring shell..."

SOURCE_LINE="source $DOTFILES_DIR/bashrc_custom"

if grep -qF "$SOURCE_LINE" ~/.bashrc 2>/dev/null; then
  echo "  bashrc_custom is already sourced, skipping."
else
  echo "  Adding bashrc_custom to ~/.bashrc..."
  echo "" >> ~/.bashrc
  echo "$SOURCE_LINE" >> ~/.bashrc
fi

echo "==> Shell config complete. Restart your shell or run: source ~/.bashrc"
