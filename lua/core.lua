-- omarchy-vimified: core.lua
-- Core Vim-style window navigation, collision overrides, and Omarchy Shell HUD helpers

local M = {}

-- Ensure reference to Hyprland and Omarchy globals
local hl = _G.hl
local o = _G.o

-- Hub targets registry for extensible submap navigation
M.hub_targets = {
  { keys = { "s", "S" }, name = "System" },
  { keys = { "l", "L" }, name = "Learning" },
  { keys = { "p", "P" }, name = "Programming" },
  { keys = { "o", "O" }, name = "Office" },
  { keys = { "i", "I" }, name = "IA" },
  { keys = { "n", "N" }, name = "NAV" },
  { keys = { "f", "F" }, name = "Frames" },
  { keys = { "e", "E" }, name = "Workspaces" },
  { keys = { "d", "D" }, name = "Resize" },
  { keys = { "m", "M" }, name = "Media" },
  { keys = { "r", "R" }, name = "Reminders" },
  { keys = { "t", "T" }, name = "TTS" },
}

--- Register an additional target in the Hub submap
--- @param keys table|string Single key or array of keys (e.g. { "u", "U" })
--- @param submap_name string Name of the submap (e.g. "UNLP")
function M.register_hub_target(keys, submap_name)
  local keys_table = type(keys) == "table" and keys or { keys }
  table.insert(M.hub_targets, { keys = keys_table, name = submap_name })
end

--- Summon the omarchy-vimified HUD cheatsheet via Omarchy Shell IPC
--- @param submap_name string
function M.show_submap_cheatsheet(submap_name)
  local cmd = string.format("omarchy-shell shell summon omarchy-vimified '{\"submap\":\"%s\"}'", submap_name)
  hl.exec_cmd(cmd)
end

--- Hide the omarchy-vimified HUD cheatsheet via Omarchy Shell IPC
function M.dismiss_cheatsheet()
  hl.exec_cmd("omarchy-shell shell hide omarchy-vimified")
end

--- Reset Hyprland submap to default and dismiss the HUD cheatsheet
function M.reset_submap()
  hl.dispatch(hl.dsp.submap("reset"))
  M.dismiss_cheatsheet()
end

--- Enter a child submap from within a parent submap (breadcrumb navigation)
--- @param parent_name string Current parent submap name
--- @param child_name string Target child submap name
function M.enter_child_submap(parent_name, child_name)
  local breadcrumb = parent_name .. " > " .. child_name
  local cmd = string.format(
    "omarchy-shell shell summon omarchy-vimified '{\"submap\":\"%s\",\"breadcrumb\":\"%s\"}'",
    child_name, breadcrumb
  )
  hl.exec_cmd(cmd)
  hl.dispatch(hl.dsp.submap(child_name))
end

--- Create a keybinding inside a submap that resets the submap and runs a command
--- @param keys table|string Single key or list of keys (e.g. "f" or { "G", "SHIFT + g" })
--- @param description string Human-readable description for cheatsheet and menus
--- @param command string|function Shell command string or Lua function to execute
function M.submap_cmd(keys, description, command)
  local function action()
    M.reset_submap()
    if type(command) == "string" then
      hl.exec_cmd(command)
    elseif type(command) == "function" then
      command()
    end
  end

  local keys_table = type(keys) == "table" and keys or { keys }
  for _, key in ipairs(keys_table) do
    hl.bind(key, action, { description = description })
  end
end

--- Register a global trigger to enter a submap with HUD display
--- @param key_char string Trigger key (e.g. "S" -> ALT + s)
--- @param submap_name string Name of the submap
--- @param modifier string? Optional modifier, defaults to "ALT"
function M.bind_submap(key_char, submap_name, modifier)
  local mod = modifier or "ALT"
  local function enter_submap()
    M.show_submap_cheatsheet(submap_name)
    hl.dispatch(hl.dsp.submap(submap_name))
  end

  hl.bind(mod .. " + " .. key_char:lower(), enter_submap)
  hl.bind(mod .. " + " .. key_char:upper(), enter_submap)
end

--- Set up Vim HJKL navigation, swapping, and Omarchy default collision remappings
function M.setup_navigation()
  -- 1. Unbind conflicting Omarchy defaults
  hl.unbind("SUPER + J")
  hl.unbind("SUPER + K")
  hl.unbind("SUPER + L")
  hl.unbind("SUPER + CTRL + L")

  -- 1b. Unbind window management defaults (absorbed into Frames submap)
  hl.unbind("SUPER + F")           -- fullscreen
  hl.unbind("SUPER + CTRL + F")    -- tiled fullscreen
  hl.unbind("SUPER + ALT + F")     -- maximized
  hl.unbind("SUPER + T")           -- toggle float
  hl.unbind("SUPER + P")           -- pseudo
  hl.unbind("SUPER + O")           -- pop-out
  hl.unbind("SUPER + G")           -- toggle group
  hl.unbind("SUPER + ALT + G")     -- move out of group

  -- 1c. Unbind app launchers (absorbed into contextual submaps)
  hl.unbind("SUPER + SHIFT + RETURN")  -- browser (duplicate)
  hl.unbind("SUPER + SHIFT + B")       -- browser
  hl.unbind("SUPER + SHIFT + F")       -- file manager
  hl.unbind("SUPER + SHIFT + N")       -- editor
  hl.unbind("SUPER + SHIFT + M")       -- music
  hl.unbind("SUPER + SHIFT + D")       -- docker
  hl.unbind("SUPER + SHIFT + G")       -- signal
  hl.unbind("SUPER + SHIFT + O")       -- obsidian
  hl.unbind("SUPER + SHIFT + W")       -- omawrite
  hl.unbind("SUPER + SHIFT + A")       -- chatgpt
  hl.unbind("SUPER + SHIFT + C")       -- calendar
  hl.unbind("SUPER + SHIFT + E")       -- email
  hl.unbind("SUPER + SHIFT + Y")       -- youtube
  hl.unbind("SUPER + SHIFT + P")       -- photos
  hl.unbind("SUPER + SHIFT + S")       -- maps
  hl.unbind("SUPER + SHIFT + X")       -- twitter

  -- 1d. Unbind utility panels (absorbed into System/Menus submaps)
  hl.unbind("SUPER + CTRL + E")    -- emojis
  hl.unbind("SUPER + CTRL + C")    -- capture
  hl.unbind("SUPER + CTRL + O")    -- toggle menu
  hl.unbind("SUPER + CTRL + H")    -- hardware
  hl.unbind("SUPER + CTRL + A")    -- audio
  hl.unbind("SUPER + CTRL + B")    -- bluetooth
  hl.unbind("SUPER + CTRL + D")    -- display
  hl.unbind("SUPER + CTRL + W")    -- network
  hl.unbind("SUPER + CTRL + P")    -- power
  hl.unbind("SUPER + CTRL + S")    -- share
  hl.unbind("SUPER + CTRL + Q")    -- calculator
  hl.unbind("SUPER + CTRL + T")    -- activity
  hl.unbind("SUPER + CTRL + N")    -- nightlight
  hl.unbind("SUPER + CTRL + I")    -- idle lock
  hl.unbind("SUPER + CTRL + Z")    -- zoom

  -- 2. Focus Navigation (SUPER + H/J/K/L)
  o.bind("SUPER + H", "Focus left window", hl.dsp.focus({ direction = "l" }))
  o.bind("SUPER + J", "Focus below window", hl.dsp.focus({ direction = "d" }))
  o.bind("SUPER + K", "Focus above window", hl.dsp.focus({ direction = "u" }))
  o.bind("SUPER + L", "Focus right window", hl.dsp.focus({ direction = "r" }))

  -- 3. Window Swapping (SUPER + SHIFT + H/J/K/L)
  o.bind("SUPER + SHIFT + H", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
  o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
  o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
  o.bind("SUPER + SHIFT + L", "Swap window right", hl.dsp.window.swap({ direction = "r" }))

  -- 4. Reassign conflicting Omarchy defaults to safe shortcuts
  o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))
  o.bind("SUPER + CTRL + K", "Keybindings menu", "omarchy-menu-keybindings")
  o.bind("SUPER + CTRL + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
end

-- Expose to global namespace for custom user configs and modules
_G.omarchy_vimified = M

return M
