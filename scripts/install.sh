#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing packages and apps..."

# ── Packages ─────────────────────────────────────────────────────────
PACMAN_PACKAGES=(
  code          # VS Code
)

AUR_PACKAGES=(
  1password-beta  # 1Password
  1password-cli   # 1Password CLI
)

for pkg in "${PACMAN_PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "  $pkg is already installed, skipping."
  else
    echo "  Installing $pkg..."
    sudo pacman -S --noconfirm "$pkg"
  fi
done

for pkg in "${AUR_PACKAGES[@]}"; do
  if pacman -Qi "$pkg" &>/dev/null; then
    echo "  $pkg is already installed, skipping."
  else
    echo "  Installing $pkg (AUR)..."
    yay -S --noconfirm "$pkg"
  fi
done

# ── Web apps (Chrome) ───────────────────────────────────────────────
WEBAPP_DIR="$HOME/.local/share/applications"
ICON_DIR="$WEBAPP_DIR/icons"
mkdir -p "$ICON_DIR"

declare -A WEBAPPS=(
  ["WhatsApp"]="https://web.whatsapp.com/"
  ["Discord"]="https://discord.com/channels/@me"
)

for app in "${!WEBAPPS[@]}"; do
  desktop_file="$WEBAPP_DIR/$app.desktop"
  if [ -f "$desktop_file" ]; then
    echo "  Web app $app is already installed, skipping."
  else
    echo "  Installing web app: $app..."
    cat > "$desktop_file" <<DESKTOP
[Desktop Entry]
Version=1.0
Name=$app
Comment=$app
Exec=omarchy-launch-webapp ${WEBAPPS[$app]}
Terminal=false
Type=Application
Icon=$ICON_DIR/$app.png
StartupNotify=true
DESKTOP
  fi
done

echo "==> Install complete."
