#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="$SCRIPT_DIR/../dotfiles/nvim"
PACK_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"

echo "==> Setting up neovim..."

# Remove omarchy-nvim package
if pacman -Qi omarchy-nvim &>/dev/null; then
  echo "  Removing omarchy-nvim package..."
  sudo pacman -Rns --noconfirm omarchy-nvim 2>/dev/null || echo "  Warning: could not fully remove omarchy-nvim"
fi

# Clean existing nvim state
echo "  Cleaning existing nvim config and cache..."
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Link our config
echo "  Linking nvim config..."
ln -sf "$NVIM_CONFIG" ~/.config/nvim

# Install plugins via native packages (git clone)
echo "  Installing plugins..."
mkdir -p "$PACK_DIR"

PLUGINS=(
  "catppuccin/nvim catppuccin"
  "nvim-treesitter/nvim-treesitter nvim-treesitter"
  "nvim-telescope/telescope.nvim telescope.nvim"
  "nvim-telescope/telescope-fzf-native.nvim telescope-fzf-native.nvim"
  "nvim-lua/plenary.nvim plenary.nvim"
  "nvim-tree/nvim-tree.lua nvim-tree.lua"
  "nvim-tree/nvim-web-devicons nvim-web-devicons"
  "mbbill/undotree undotree"
  "lewis6991/gitsigns.nvim gitsigns.nvim"
  "nvim-lualine/lualine.nvim lualine.nvim"
  "neovim/nvim-lspconfig nvim-lspconfig"
  "williamboman/mason.nvim mason.nvim"
  "williamboman/mason-lspconfig.nvim mason-lspconfig.nvim"
)

for entry in "${PLUGINS[@]}"; do
  repo="${entry%% *}"
  dir="${entry##* }"
  if [ -d "$PACK_DIR/$dir" ]; then
    echo "    $dir already installed, skipping."
  else
    echo "    Cloning $repo..."
    git clone --depth 1 "https://github.com/$repo.git" "$PACK_DIR/$dir"
  fi
done

# Build telescope-fzf-native
if [ -d "$PACK_DIR/telescope-fzf-native.nvim" ]; then
  echo "  Building telescope-fzf-native..."
  make -C "$PACK_DIR/telescope-fzf-native.nvim" 2>/dev/null || echo "  Warning: fzf-native build failed (needs gcc/make)"
fi

# Install treesitter parsers
echo "  Installing treesitter parsers..."
nvim --headless -c "TSUpdateSync" -c "qa" 2>/dev/null || echo "  Note: run :TSUpdate manually on first launch"

echo "==> Neovim setup complete."
