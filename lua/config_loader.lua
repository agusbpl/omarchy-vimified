-- omarchy-vimified: config_loader.lua
-- Declarative configuration loader and compiler for omarchy-vimified

local M = {}

local hl = _G.hl
local home = os.getenv("HOME") or ""

--- Parse a trigger string like "ALT + F", "F", or "f" into key letter and modifier
--- @param trigger string?
--- @return string key_char
--- @return string modifier
local function parse_trigger(trigger)
  if not trigger or trigger == "" then
    return "X", "ALT"
  end
  local mod, key = trigger:match("([%a%+]+)%s*%+%s*(%a+)")
  if mod and key then
    return key:upper(), mod:upper()
  end
  return trigger:upper(), "ALT"
end

--- Serialize a Lua table of submaps into simple JSON for ~/.config/omarchy/submaps.json
--- @param submaps_map table
--- @return string json_str
function M.serialize_submaps_to_json(submaps_map)
  local parts = {}
  for name, data in pairs(submaps_map) do
    local entry_parts = {}
    for _, e in ipairs(data.entries or {}) do
      local k = tostring(e[1] or ""):gsub('"', '\\"')
      local desc = tostring(e[2] or ""):gsub('"', '\\"')
      table.insert(entry_parts, string.format('["%s","%s"]', k, desc))
    end
    local icon = tostring(data.icon or "⚡"):gsub('"', '\\"')
    local title = tostring(data.title or name):gsub('"', '\\"')
    local tag = tostring(data.tag or ("SUBMAP [" .. name:upper() .. "]")):gsub('"', '\\"')
    local sm_json = string.format(
      '"%s":{"icon":"%s","title":"%s","tag":"%s","entries":[%s]}',
      name:gsub('"', '\\"'),
      icon,
      title,
      tag,
      table.concat(entry_parts, ",")
    )
    table.insert(parts, sm_json)
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

--- Sync custom submap definitions to ~/.config/omarchy/submaps.json
--- @param custom_submaps table
function M.sync_json_catalog(custom_submaps)
  local omarchy_dir = home .. "/.config/omarchy"
  local json_path = omarchy_dir .. "/submaps.json"

  -- Ensure ~/.config/omarchy exists
  os.execute(string.format("mkdir -p %q", omarchy_dir))

  local json_content = M.serialize_submaps_to_json(custom_submaps)
  local f = io.open(json_path, "w")
  if f then
    f:write(json_content)
    f:close()
  end
end

--- Load declarative configuration from ~/.config/hypr/omarchy-vimified-config.lua
--- @param core table Reference to core module
--- @return boolean success
function M.load_declarative_config(core)
  local config_path = home .. "/.config/hypr/omarchy-vimified-config.lua"
  local f = io.open(config_path, "r")
  if not f then
    return false
  end
  f:close()

  local chunk, load_err = loadfile(config_path)
  if not chunk then
    local msg = "Syntax error in omarchy-vimified-config.lua: " .. tostring(load_err)
    if hl and hl.exec_cmd then
      hl.exec_cmd(string.format("omarchy-notification-send -u critical 'omarchy-vimified' %q", msg))
    end
    return false
  end

  local ok, cfg = pcall(chunk)
  if not ok or type(cfg) ~= "table" then
    local msg = "Error evaluating omarchy-vimified-config.lua: " .. tostring(cfg)
    if hl and hl.exec_cmd then
      hl.exec_cmd(string.format("omarchy-notification-send -u normal 'omarchy-vimified' %q", msg))
    end
    return false
  end

  local json_submaps = {}

  -- 1. Register custom submaps defined declaratively
  if type(cfg.submaps) == "table" then
    for _, sm in ipairs(cfg.submaps) do
      if sm.name and type(sm.entries) == "table" then
        local sm_name = sm.name
        local key_char, mod = parse_trigger(sm.trigger or sm.name:sub(1, 1))

        hl.define_submap(sm_name, function()
          for _, entry in ipairs(sm.entries) do
            if entry.key and entry.cmd then
              core.submap_cmd(entry.key, entry.label or entry.name or entry.cmd, entry.cmd)
            end
          end
          hl.bind("ESCAPE", core.reset_submap)
        end)

        -- Bind global entrance trigger (e.g. ALT + W)
        core.bind_submap(key_char, sm_name, mod)

        -- Register in Master Hub
        core.register_hub_target({ key_char:lower(), key_char:upper() }, sm_name)

        -- Build metadata for HUD
        local entries_arr = {}
        for _, entry in ipairs(sm.entries) do
          table.insert(entries_arr, { entry.key, entry.label or entry.name or entry.cmd })
        end

        json_submaps[sm_name] = {
          icon = sm.icon or "⚡",
          title = sm.title or sm_name,
          tag = sm.tag or string.format("SUBMAP [%s + %s]", mod, key_char),
          entries = entries_arr,
        }
      end
    end
  end

  -- 2. Synchronize Quickshell HUD catalog if any submaps were defined
  if next(json_submaps) ~= nil then
    M.sync_json_catalog(json_submaps)
  end

  return true
end

return M
