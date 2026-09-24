# ⚡ omarchy-vimified

<p align="center">
  <strong>Vim-style modal submaps, directional HJKL window navigation, and real-time Which-Key HUD for Omarchy Linux.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Omarchy%20Linux%20%2F%20Hyprland-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/UI-Quickshell%20Layer%20Shell-purple?style=flat-square" alt="Quickshell">
  <img src="https://img.shields.io/badge/Core-Lua%205.1-yellow?style=flat-square" alt="Lua">
  <img src="https://img.shields.io/badge/Tests-96%20Passed-brightgreen?style=flat-square" alt="Tests">
  <img src="https://img.shields.io/badge/License-MIT-orange?style=flat-square" alt="License">
</p>

---

## 💡 Overview

**`omarchy-vimified`** transforms your [Omarchy](https://github.com/basecamp/omarchy) / Hyprland desktop into a keyboard-centric power environment inspired by Vim and Which-Key.

Instead of stretching fingers for complex multi-key shortcuts or relying on mouse navigation:
1. **Navigate Windows with `HJKL`:** Move focus and swap tiling windows intuitively using familiar Vim directional keys (`SUPER + H/J/K/L`).
2. **Modal Workflow Submaps:** Access system functions, developer tools, AI workflows, and document suites through cleanly categorized modes triggered by `ALT + <key>`.
3. **The Master Hub (`ALT + ENTER`):** A centralized springboard providing immediate visual access to every submap on your machine.
4. **Native Quickshell Which-Key HUD:** An instant, zero-latency heads-up display rendered in the top-right corner. It dynamically adapts to your active Omarchy color scheme (`omarchy theme set`), uses high-contrast JetBrains Mono typography, inline SVG icons, and a non-blocking Layer Shell mask (never intercepts clicks or steals window focus).

---

## 🖥️ Visual Architecture

```text
               ┌──────────────────────────────┐
               │    Hyprland Compositor       │
               │  (bindings.lua / Hypr IPC)   │
               └──────────────┬───────────────┘
                              │
                    ALT + Key │ Super + HJKL
                              ▼
    ┌────────────────────────────────────────────────────────┐
    │                 omarchy-vimified (Core)                │
    │  • HJKL Directional Navigation & Window Swapping       │
    │  • Collision-safe Unbinds (SUPER + J/K/L remapped)     │
    │  • Submap State Machine & Custom Extensibility Loader  │
    └─────────────────────────┬──────────────────────────────┘
                              │ IPC (show/hide payload)
                              ▼
    ┌────────────────────────────────────────────────────────┐
    │          Quickshell Overlay (Overlay.qml)              │
    │  • Pure Terminal Aesthetic (Square corners, 0px radius)│
    │  • Active Omarchy Theme Palette (Theme.surface/primary)│
    │  • Dynamic 1- or 2-Column Responsive Card Grid         │
    │  • Transparent Layer Shell Mask (Zero click-capture)   │
    └────────────────────────────────────────────────────────┘
```

### HUD Preview (Terminal / Which-Key Aesthetic)

```text
 ┌─ [⚡] SYSTEM ──────────────────────────────────────────┐
 │                                                        │
 │   [ f ] Files (Nautilus)      [ r ] Record Video       │
 │   [ m ] Btop System Monitor   [ s ] Screenshot         │
 │   [ e ] Edit Binds (Neovim)   [ a ] Audio Settings     │
 │   [ w ] WiFi Network Menu     [ p ] Clipboard History  │
 │   [ b ] Bluetooth Devices     [ q ] Shutdown System    │
 │   [ c ] Activate Camera       [ v ] +Volume...         │
 │                               [ l ] +Brightness...     │
 ├────────────────────────────────────────────────────────┤
 │   [ ESC ] exit                                         │
 └────────────────────────────────────────────────────────┘
```

---

## 🚀 Installation

### Option 1: Native Omarchy CLI (Recommended)

Omarchy includes a built-in plugin manager. You can add and enable `omarchy-vimified` directly from GitHub:

```bash
# 1. Add and enable the plugin in Omarchy Shell
omarchy plugin add https://github.com/agusbpl/omarchy-vimified.git --enable

# 2. Run the post-install hook to connect Hyprland bindings & generate user config
~/.config/omarchy/plugins/omarchy-vimified/install.sh
```

### Option 2: Standard Git Clone

```bash
git clone https://github.com/agusbpl/omarchy-vimified.git
cd omarchy-vimified
./install.sh
```

### What `install.sh` Does Automatically:
- ✅ **Validates** plugin manifest and entry points using `omarchy-plugin-validate`.
- ✅ **Deploys** files to `~/.config/omarchy/plugins/omarchy-vimified`.
- ✅ **Registers** and enables the overlay in `omarchy-shell`.
- ✅ **Hooks safely** into `~/.config/hypr/bindings.lua` (with automatic backup).
- ✅ **Generates** a starter custom configuration at `~/.config/hypr/omarchy-vimified-custom.lua`.
- ✅ **Reloads** Hyprland configuration live with `hyprctl reload` (zero downtime).

---

## ⌨️ Default Keybindings

### 1. Vim Directional Window Management

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `SUPER + H` | **Focus Left** | Move focus to the window on the left |
| `SUPER + J` | **Focus Down** | Move focus to the window below |
| `SUPER + K` | **Focus Up** | Move focus to the window above |
| `SUPER + L` | **Focus Right** | Move focus to the window on the right |
| `SUPER + SHIFT + H` | **Swap Left** | Swap active window with the one on the left |
| `SUPER + SHIFT + J` | **Swap Down** | Swap active window with the one below |
| `SUPER + SHIFT + K` | **Swap Up** | Swap active window with the one above |
| `SUPER + SHIFT + L` | **Swap Right** | Swap active window with the one on the right |

> [!NOTE]
> **Conflict Resolution:** Omarchy defaults that previously clashed with `SUPER + J/K/L` are safely remapped to:
> - `SUPER + CTRL + J` → Toggle split direction
> - `SUPER + CTRL + K` → Omarchy Keybindings Menu
> - `SUPER + CTRL + L` → Cycle master/dwindle workspace layout

---

### 2. The Master Hub & Submaps

Press `ALT + <Key>` to enter a modal submap. The Which-Key HUD will immediately appear in the top-right corner. Press any listed key to execute its action, or press `Escape` / `Return` to exit back to normal mode.

| Trigger | Submap Name | Content & Actions |
| :--- | :--- | :--- |
| `ALT + ENTER` | **⚡ Master Hub** | Springboard linking directly into all submaps (`s`, `l`, `p`, `o`, `i`, `n`, `f`, `d`, `m`, `r`, `t`) |
| `ALT + F` | **🖥️ Frames** | **Unified Window Management:** Fullscreen (`f`), Boxed/Tiled Fullscreen (`b`), Maximized (`m`), Float/Tile (`t`), Pseudo (`p`), Pop-out (`o`), Split (`s`), Group (`g`), Ungroup (`u`), Width presets (`w`/`r`), Lock screen (`l`) |
| `ALT + D` | **📐 Window Resize** | Modal micro-adjustments (**D**imensions: `h`/`l` width 10px, `j`/`k` height 10px, `H`/`L`/`J`/`K` fast 30px, `s`/`r` save & restore width) |
| `ALT + S` | **⚙️ System & Hardware** | Nautilus (`f`), Btop (`m`), Edit binds (`e`), WiFi (`w`), Bluetooth (`b`), Camera (`y`), Video record (`r`), Screenshot (`s`), Audio (`a`), Clipboard (`p`), Nightlight (`n`), Idle (`i`), Zoom (`z`), Display (`d`), Theme (`t`), Wallpaper (`g`), Top Bar (`u`), Keybindings (`k`), Capture (`c`), Power (`o`), Lock (`x`), Shutdown (`q`), Volume (`v`), Brightness (`l`) |
| `ALT + P` | **💻 Programming & Dev** | Antigravity AI (`a`), Colab (`c`), Zed (`e`), Terminal (`t`), JupyterLab (`j`), LazyGit (`g`), GitHub Web (`h`), Discord (`d`) |
| `ALT + L` | **📚 Learning & Data** | Python, Pandas, Polars, PyTorch, SQL, Jupyter, Hugging Face, documentation and local cheatsheets |
| `ALT + I` | **🤖 AI & Assistants** | Gemini, Claude, ChatGPT, Mistral AI, Perplexity, DeepSeek, Kimi, NotebookLM, OpenCode, Grok, Phind, Voice dictation |
| `ALT + O` | **📝 Office & Documents** | Obsidian notes (`n`), OnlyOffice (`o`), Gmail (`m`), Docs (`d`), Sheets (`s`), Okular/Zathura PDF (`p`/`z`), DeepL (`t`), WordReference (`w`), Wikipedia (`k`), Excalidraw (`e`), Reading Tracker (`r`), Calculator (`c`), Emojis picker (`i`) |
| `ALT + N` | **🌐 Navigation & Web** | Browser (`b`), Gmail (`m`), YouTube (`y`), YouTube Studio (`s`), Telegram (`t`), WhatsApp Web (`w`), X / Twitter (`x`) |
| `ALT + M` | **🎵 Media Player** | Spotify (`s`), Cliamp TUI (`c`), Play/Pause (`Space`), Next/Prev track (`l`/`h`), Volume control (`k`/`j`), Mute (`m`) |
| `ALT + R` | **🔔 Reminders & Alerts** | Set timer, view active reminders, dismiss alerts, silence notifications |
| `ALT + T` | **🗣️ Text to Speech** | Read selection aloud via Piper TTS (Spanish / English voices) |

---

## 🛠️ omarchy-vimified CLI Utility

Manage, validate, add shortcuts, and query active submaps directly from your terminal:

```bash
# List all active submaps
omarchy-vimified list

# Inspect keys within a specific submap
omarchy-vimified list Frames

# Add a custom shortcut to your declarative config in one command:
omarchy-vimified add --submap Work --trigger "ALT + W" --key d --label "Dashboard" --cmd "omarchy-launch-webapp 'http://localhost:3000'"

# Validate Lua syntax of all plugin and user configs
omarchy-vimified validate

# Live reload Hyprland bindings and Which-Key HUD
omarchy-vimified reload
```

---

## 🧩 User Customization & Extensibility

### 1. Declarative Configuration (Recommended for Users & AI Agents)

Define your submaps simply as structured Lua tables in `~/.config/hypr/omarchy-vimified-config.lua`:

```lua
return {
  submaps = {
    {
      name = "Work",
      trigger = "ALT + W",
      icon = "💼",
      title = "Work Projects",
      entries = {
        { key = "d", label = "Dashboard Local", cmd = "omarchy-launch-webapp 'http://localhost:3000'" },
        { key = "s", label = "Dev Server", cmd = "uwsm-app -- xdg-terminal-exec -e bash -c 'npm run dev'" },
        { key = "g", label = "Lazygit", cmd = "uwsm-app -- xdg-terminal-exec -e lazygit" },
      },
    },
  },
  options = {
    absorb_defaults = true,
    hud_breadcrumb = true,
  },
}
```

The plugin automatically parses this table upon launch, binds all modal keys, registers the submap into the Master Hub, and exports the metadata into `~/.config/omarchy/submaps.json` so the Quickshell Which-Key HUD renders it in real-time.

### 2. Imperative Custom Configuration (Advanced)

For advanced hooks, custom functions, or scripts, edit `~/.config/hypr/omarchy-vimified-custom.lua`:

```lua
local vim = _G.omarchy_vimified
local hl = _G.hl

hl.define_submap("UNLP", function()
  vim.submap_cmd("a", "AU24", "omarchy-launch-webapp 'https://www.au24-2021.econo.unlp.edu.ar/'")
  hl.bind("ESCAPE", vim.reset_submap)
end)

vim.bind_submap("U", "UNLP")
vim.register_hub_target({ "u", "U" }, "UNLP")
```

---

## 🎨 Theme Integration

`omarchy-vimified` is designed strictly around the Omarchy design system:
- **Zero Hardcoded Colors:** Uses native `Theme.surface`, `Theme.background`, `Theme.primary`, `Theme.outline`, and `Theme.onSurface`.
- **Live Theme Switching:** When you run `omarchy theme set <theme>`, the HUD immediately repaints in the new palette.
- **Pure Terminal Aesthetic:** Crisp `0px` square borders, clean separator lines, and JetBrains Mono monospace formatting.
- **Vector Icons Only:** Inline SVG paths for all categories prevent missing gliphs or empty rectangles (*tofu*) on minimal Arch Linux installations.

---

## 🧪 Testing & Verification

The repository includes a comprehensive 5-stage automated test suite:

```bash
./tests/verify.sh
```

1. **Lua Syntax:** Static check with `luac -p` across all Lua modules.
2. **47 Unit Tests:** Mock compositor test suite verifying collision unbinds, HJKL navigation, swap logic, IPC payloads, and trigger handlers.
3. **Manifest Linting:** Validation with `omarchy-plugin-validate` ensuring strict schema compliance.
4. **QML Linting:** Inspection with `qmllint` against Omarchy Shell imports.
5. **Model Verification:** Node.js validation verifying catalog consistency and JSON parsing.

---

## 🗑️ Uninstallation

If you ever wish to uninstall, the included uninstaller reverts your setup cleanly:

```bash
~/.config/omarchy/plugins/omarchy-vimified/uninstall.sh
```

This will:
1. Disable the plugin in Omarchy Shell.
2. Remove the loader hook from `~/.config/hypr/bindings.lua`.
3. Delete the plugin directory in `~/.config/omarchy/plugins/omarchy-vimified`.
4. Reload Hyprland. *(Your personal `~/.config/hypr/omarchy-vimified-custom.lua` is preserved).*

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for details.

Built by [Agustín Barthe](https://github.com/agusbpl) for the Omarchy and Hyprland community. Contributions, pull requests, and suggestions are welcome!
