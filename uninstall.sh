#!/usr/bin/env bash
# ==============================================================================
# omarchy-vimified: uninstall.sh
# Clean uninstaller for Omarchy Vimified plugin
# ==============================================================================
set -euo pipefail

TARGET_DIR="$HOME/.config/omarchy/plugins/omarchy-vimified"
HYPR_CONFIG_DIR="$HOME/.config/hypr"
BINDINGS_LUA="$HYPR_CONFIG_DIR/bindings.lua"

echo -e "\033[1;33m:: Uninstalling omarchy-vimified...\033[0m"

# 1. Disable in Omarchy Shell
if command -v omarchy-plugin-disable >/dev/null 2>&1; then
  echo "-> Disabling plugin in Omarchy Shell..."
  omarchy-plugin-disable omarchy-vimified >/dev/null 2>&1 || true
fi

# 2. Remove from Hyprland bindings.lua
if [ -f "$BINDINGS_LUA" ]; then
  echo "-> Removing loader from $BINDINGS_LUA..."
  sed -i '/-- \[omarchy-vimified: start\]/,/-- \[omarchy-vimified: end\]/d' "$BINDINGS_LUA"
  echo -e "\033[32m✔ Removed omarchy-vimified hooks from $BINDINGS_LUA\033[0m"
fi

# 3. Remove plugin directory
if [ -d "$TARGET_DIR" ]; then
  echo "-> Removing plugin files at $TARGET_DIR..."
  rm -rf "$TARGET_DIR"
  echo -e "\033[32m✔ Plugin folder removed.\033[0m"
fi

# 4. Rescan plugins
if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

# 5. Reload Hyprland
if command -v hyprctl >/dev/null 2>&1; then
  echo "-> Reloading Hyprland configuration..."
  hyprctl reload >/dev/null 2>&1 || true
  echo -e "\033[32m✔ Hyprland reloaded.\033[0m"
fi

echo -e "\033[1;32m✔ omarchy-vimified has been uninstalled successfully.\033[0m"
