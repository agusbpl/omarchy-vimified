#!/usr/bin/env bash
# ==============================================================================
# omarchy-vimified: install.sh
# End-to-end installer for Omarchy Vimified plugin
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/omarchy/plugins/omarchy-vimified"
HYPR_CONFIG_DIR="$HOME/.config/hypr"
BINDINGS_LUA="$HYPR_CONFIG_DIR/bindings.lua"
CUSTOM_LUA="$HYPR_CONFIG_DIR/omarchy-vimified-custom.lua"
CONFIG_LUA="$HYPR_CONFIG_DIR/omarchy-vimified-config.lua"

echo -e "\033[1;34m:: Installing omarchy-vimified...\033[0m"

# 1. Validate Plugin Manifest and Components
echo "-> Validating plugin manifest..."
if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  omarchy-plugin-validate "$DIR"
  echo -e "\033[32m✔ Plugin structure and manifest.json are valid.\033[0m"
else
  echo -e "\033[33m⚠ omarchy-plugin-validate not found, skipping manifest check.\033[0m"
fi

# 2. Install to Omarchy plugins directory
mkdir -p "$HOME/.config/omarchy/plugins"
if [ "$DIR" != "$TARGET_DIR" ]; then
  echo "-> Syncing plugin files to $TARGET_DIR..."
  mkdir -p "$TARGET_DIR"
  # Copy files excluding git directory if any
  rsync -a --exclude='.git' --delete "$DIR/" "$TARGET_DIR/"
  echo -e "\033[32m✔ Plugin installed to $TARGET_DIR\033[0m"
else
  echo -e "\033[32m✔ Running directly from $TARGET_DIR\033[0m"
fi

# 3. Register and Enable in Omarchy Shell
echo "-> Registering plugin in Omarchy Shell..."
if command -v omarchy-shell >/dev/null 2>&1; then
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

if command -v omarchy-plugin-enable >/dev/null 2>&1; then
  omarchy-plugin-enable omarchy-vimified >/dev/null 2>&1 || true
  echo -e "\033[32m✔ Plugin enabled in Omarchy Shell.\033[0m"
fi

# 4. Integrate Hyprland Bindings
if [ -f "$BINDINGS_LUA" ]; then
  echo "-> Integrating Vim bindings into $BINDINGS_LUA..."
  if ! grep -q "omarchy-vimified: start" "$BINDINGS_LUA"; then
    cp "$BINDINGS_LUA" "$BINDINGS_LUA.bak.$(date +%s)"
    cat >> "$BINDINGS_LUA" << 'EOF'

-- [omarchy-vimified: start]
pcall(function()
  dofile(os.getenv("HOME") .. "/.config/omarchy/plugins/omarchy-vimified/lua/init.lua")
end)
-- [omarchy-vimified: end]
EOF
    echo -e "\033[32m✔ Attached omarchy-vimified loader to $BINDINGS_LUA\033[0m"
  else
    echo -e "\033[32m✔ omarchy-vimified is already loaded in $BINDINGS_LUA\033[0m"
  fi
else
  echo -e "\033[33m⚠ $BINDINGS_LUA not found. Ensure Hyprland loads the plugin via:\033[0m"
  echo "  dofile(os.getenv(\"HOME\") .. \"/.config/omarchy/plugins/omarchy-vimified/lua/init.lua\")"
fi

# 5. Template User Custom Configurations if missing
if [ ! -f "$CUSTOM_LUA" ]; then
  echo "-> Creating starter custom config: $CUSTOM_LUA..."
  cp "$TARGET_DIR/lua/custom.lua.example" "$CUSTOM_LUA"
  echo -e "\033[32m✔ Starter custom config created.\033[0m"
fi

if [ ! -f "$CONFIG_LUA" ]; then
  echo "-> Creating starter declarative config: $CONFIG_LUA..."
  cp "$TARGET_DIR/lua/config.lua.example" "$CONFIG_LUA"
  echo -e "\033[32m✔ Starter declarative config created.\033[0m"
fi

# 6. Install omarchy-vimified CLI tool
mkdir -p "$HOME/.local/bin"
if [ -f "$TARGET_DIR/bin/omarchy-vimified" ]; then
  echo "-> Installing CLI to $HOME/.local/bin/omarchy-vimified..."
  cp "$TARGET_DIR/bin/omarchy-vimified" "$HOME/.local/bin/omarchy-vimified"
  chmod +x "$HOME/.local/bin/omarchy-vimified"
  echo -e "\033[32m✔ CLI installed to $HOME/.local/bin/omarchy-vimified\033[0m"
fi

# 7. Reload Hyprland
if command -v hyprctl >/dev/null 2>&1; then
  echo "-> Reloading Hyprland configuration..."
  hyprctl reload >/dev/null 2>&1 || true
  echo -e "\033[32m✔ Hyprland reloaded.\033[0m"
fi

echo ""
echo -e "\033[1;32m🎉 omarchy-vimified installed and active!\033[0m"
echo -e "Quick Reference:"
echo -e "  • \033[1mSUPER + H/J/K/L\033[0m         : Focus left / down / up / right"
echo -e "  • \033[1mSUPER + SHIFT + H/J/K/L\033[0m : Swap window left / down / up / right"
echo -e "  • \033[1mALT + RETURN\033[0m            : Master Hub (Alt de los Alts)"
echo -e "  • \033[1mALT + S / L / P / O / I\033[0m : Submaps (System, Learning, Dev, Office, AI)"
echo -e "  • \033[1mCustom Binds\033[0m            : Edit $CUSTOM_LUA"
