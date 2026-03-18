#!/usr/bin/env bash
set -euo pipefail

echo "==> Debloating system..."

# ── Packages to remove ──────────────────────────────────────────────
PACKAGES=(
  # Image editor
  pinta

  # Markdown editor (have neovim)
  typora

  # Office suite (using Google Docs)
  libreoffice-fresh

  # Video editor
  kdenlive

  # PDF annotation
  xournalpp

  # PDF viewer
  evince

  # Screen recording (keeping gpu-screen-recorder)
  obs-studio

  # Music
  spotify

  # Omarchy theming app
  aether

  # Calculator
  gnome-calculator

  # Local file sharing
  localsend

  # Note-taking app
  obsidian

  # Printing (not needed)
  cups
  cups-browsed
  cups-filters
  cups-pdf
  system-config-printer

  # Input method framework (no non-Latin input needed)
  fcitx5
  fcitx5-gtk
  fcitx5-qt

  # OCR engine
  tesseract
  tesseract-data-eng
)

for pkg in "${PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "  Removing $pkg..."
    sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || echo "  Warning: could not fully remove $pkg (may have dependents)"
  else
    echo "  $pkg is not installed, skipping."
  fi
done

# ── Web apps to remove ──────────────────────────────────────────────
WEBAPPS=(
  "YouTube"
  "Zoom"
  "GitHub"
  "Basecamp"
)

WEBAPP_DIR="$HOME/.local/share/applications"

for app in "${WEBAPPS[@]}"; do
  desktop_file="$WEBAPP_DIR/$app.desktop"
  if [ -f "$desktop_file" ]; then
    echo "  Removing web app: $app..."
    rm "$desktop_file"
    # Also remove icon if present
    rm -f "$WEBAPP_DIR/icons/$app.png"
  else
    echo "  Web app $app is not installed, skipping."
  fi
done

echo "==> Debloat complete."
