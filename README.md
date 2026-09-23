# ⚡ omarchy-vimified

<p align="center">
  <strong>Vim-style modal submaps, directional HJKL window navigation, and real-time Which-Key HUD for Omarchy Linux.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Omarchy%20Linux%20%2F%20Hyprland-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/UI-Quickshell%20Layer%20Shell-purple?style=flat-square" alt="Quickshell">
  <img src="https://img.shields.io/badge/Core-Lua%205.1-yellow?style=flat-square" alt="Lua">
  <img src="https://img.shields.io/badge/Tests-47%20Passed-brightgreen?style=flat-square" alt="Tests">
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
| `SUPER + ALT + H` | **Resize Left** | Shrink window width (-30px, continuous repeat) |
| `SUPER + ALT + L` | **Resize Right** | Expand window width (+30px, continuous repeat) |
| `SUPER + ALT + J` | **Resize Down** | Expand window height (+30px, continuous repeat) |
| `SUPER + ALT + K` | **Resize Up** | Shrink window height (-30px, continuous repeat) |

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
| `ALT + ENTER` | **⚡ Master Hub** | Springboard linking directly into all submaps (`s`, `l`, `p`, `o`, `i`, `n`, `w`, etc.) |
| `ALT + W` | **📐 Window Resize** | Modal quick adjustment (`h`/`l` width, `j`/`k` height, `H`/`L`/`J`/`K` fast steps, `s`/`r` save & restore width) |
| `ALT + S` | **⚙️ System & Hardware** | Nautilus, Btop, config editing, WiFi, Bluetooth, Camera, Screenshot, Screen recording, Shutdown |
| `ALT + P` | **💻 Programming & Dev** | Antigravity AI, Neovim, VSCode, Docker, LazyGit, GitHub, DB managers, Terminal scratchpads |
| `ALT + L` | **📚 Learning & Data** | Python, Pandas, Polars, PyTorch, SQL, Jupyter, Hugging Face, documentation and local cheatsheets |
| `ALT + I` | **🤖 AI & Assistants** | ChatGPT, Claude, Perplexity, DeepSeek, Local LLM UIs, Ollama |
| `ALT + O` | **📝 Office & Documents** | Obsidian notes, LibreOffice Writer/Calc, PDF reader, Google Drive, Mail client |
| `ALT + N` | **🌐 Navigation & Web** | Browser windows, private browsing, YouTube, WhatsApp Web, Discord, Telegram |
| `ALT + M` | **🎨 Omarchy Menus** | Main menu, Apps, Emoji picker, Theme selector, Wallpaper switcher, System monitors |
| `ALT + R` | **🔔 Reminders & Alerts** | Set timer, view active reminders, dismiss alerts, silence notifications |
| `ALT + T` | **🗣️ Text to Speech** | Read selection aloud via Piper TTS (Spanish / English voices) |
| `ALT + V` / `ALT + B` | **🔊 Media & Brightness** | Continuous quick adjustments (`k`/`j` for volume/brightness up & down, `m` for mute) |

---

## 🧩 User Customization & Extensibility

You can add your own shortcuts, override bindings, or register entirely new submaps **without modifying the plugin repository**.

Edit your personal config file:
```bash
nvim ~/.config/hypr/omarchy-vimified-custom.lua
```

### Example: Adding a Shortcut to an Existing Submap
```lua
local vim = _G.omarchy_vimified

-- Add a key to the existing 'System' submap:
vim.extend_submap("System", function(submap_cmd)
  submap_cmd("d", "Docker Desktop", "uwsm-app -- docker-desktop")
end)
```

### Example: Creating a Brand New Submap & Linking to Master Hub
```lua
local vim = _G.omarchy_vimified
local hl = _G.hl

-- 1. Define your custom submap
hl.define_submap("Gaming", function()
  vim.submap_cmd("s", "Steam", "uwsm-app -- steam")
  vim.submap_cmd("d", "Discord", "uwsm-app -- discord")
  vim.submap_cmd("l", "Heroic Launcher", "uwsm-app -- heroic")
  hl.bind("ESCAPE", vim.reset_submap)
end)

-- 2. Bind direct trigger: ALT + G
vim.bind_submap("g", "Gaming")

-- 3. Register inside the Master Hub (ALT + ENTER):
vim.register_hub_target({ "g", "G" }, "Gaming")
```

### JSON Submaps Support
You can also store dynamic or script-generated shortcuts in `~/.config/omarchy/submaps.json`. The Quickshell HUD and Lua loader automatically detect and merge entries on the fly.

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
