-- omarchy-vimified: init.lua
-- Entry point for the omarchy-vimified plugin in Omarchy Hyprland

local M = {}

-- Determine directory path of this file for robust relative loading
local function get_current_dir()
  local info = debug.getinfo(1, "S")
  if info and info.source and info.source:sub(1, 1) == "@" then
    return info.source:sub(2):match("(.*/)") or "./"
  end
  return "./"
end

local dir = get_current_dir()

-- Ensure directory is in package.path
if not package.path:find(dir, 1, true) then
  package.path = dir .. "?.lua;" .. package.path
end

-- 1. Load core module (HJKL window navigation, collision unbinds/rebinds, and Omarchy Shell HUD helpers)
local core = dofile(dir .. "core.lua")
core.setup_navigation()

-- 2. Load submaps module (standard submaps, user custom config loading, and Master Hub)
local submaps = dofile(dir .. "submaps.lua")

M.core = core
M.submaps = submaps
_G.omarchy_vimified = core

return M
