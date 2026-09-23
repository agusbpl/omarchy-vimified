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
  { keys = { "w", "W" }, name = "Resize" },
  { keys = { "m", "M" }, name = "Menus" },
  { keys = { "r", "R" }, name = "Reminders" },
  { keys = { "t", "T" }, name = "TTS" },
  { keys = { "v", "V" }, name = "Volume" },
  { keys = { "b", "B" }, name = "Brightness" },
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
end

--- Set up Vim HJKL navigation, swapping, and Omarchy default collision remappings
function M.setup_navigation()
  -- 1. Unbind conflicting Omarchy defaults
  hl.unbind("SUPER + J")
  hl.unbind("SUPER + K")
  hl.unbind("SUPER + L")
  hl.unbind("SUPER + CTRL + L")

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

  -- 5. Direct Window Resizing (SUPER + ALT + H/J/K/L)
  local function direct_resize(dx, dy)
    if hl.dsp and hl.dsp.window and hl.dsp.window.resize then
      return hl.dsp.window.resize({ x = dx, y = dy, relative = true })
    else
      return function() hl.exec_cmd(string.format("hyprctl dispatch resizeactive %d %d", dx, dy)) end
    end
  end

  o.bind("SUPER + ALT + H", "Shrink window width", direct_resize(-30, 0), { repeat_trigger = true })
  o.bind("SUPER + ALT + L", "Expand window width", direct_resize(30, 0), { repeat_trigger = true })
  o.bind("SUPER + ALT + J", "Expand window height", direct_resize(0, 30), { repeat_trigger = true })
  o.bind("SUPER + ALT + K", "Shrink window height", direct_resize(0, -30), { repeat_trigger = true })
end

-- Expose to global namespace for custom user configs and modules
_G.omarchy_vimified = M

return M
