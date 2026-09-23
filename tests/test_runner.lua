-- tests/test_runner.lua
-- Unit test suite for omarchy-vimified with mock Hyprland and Omarchy environments

local passed = 0
local failed = 0

local function assert_eq(actual, expected, test_name)
  if actual == expected then
    passed = passed + 1
    print(string.format("  \27[32m✔\27[0m %s", test_name))
  else
    failed = failed + 1
    print(string.format("  \27[31m✘\27[0m %s: expected %q, got %q", test_name, tostring(expected), tostring(actual)))
  end
end

local function assert_true(condition, test_name)
  if condition then
    passed = passed + 1
    print(string.format("  \27[32m✔\27[0m %s", test_name))
  else
    failed = failed + 1
    print(string.format("  \27[31m✘\27[0m %s", test_name))
  end
end

-- Mock Hyprland (hl) and Omarchy (o) APIs
local mock_unbinds = {}
local mock_binds = {}
local mock_submaps = {}
local mock_exec_cmds = {}
local mock_dispatches = {}

local hl = {
  unbind = function(key)
    table.insert(mock_unbinds, key)
  end,
  bind = function(key, action, opts)
    table.insert(mock_binds, { key = key, action = action, opts = opts })
  end,
  exec_cmd = function(cmd)
    table.insert(mock_exec_cmds, cmd)
  end,
  dispatch = function(dsp_call)
    table.insert(mock_dispatches, dsp_call)
  end,
  define_submap = function(name, callback)
    mock_submaps[name] = callback
    -- Execute callback to populate internal submap bindings
    callback()
  end,
  dsp = {
    submap = function(name)
      return { type = "submap", name = name }
    end,
    focus = function(opts)
      return { type = "focus", opts = opts }
    end,
    window = {
      swap = function(opts)
        return { type = "window.swap", opts = opts }
      end,
      resize = function(opts)
        return { type = "window.resize", opts = opts }
      end,
    },
    layout = function(name)
      return { type = "layout", name = name }
    end,
  },
}

local o = {
  bind = function(keys, description, dispatcher, opts)
    table.insert(mock_binds, {
      key = keys,
      description = description,
      dispatcher = dispatcher,
      opts = opts,
    })
  end,
}

_G.hl = hl
_G.o = o

print("\n--- Running omarchy-vimified Test Suite ---")

-- Test 1: Load init.lua
print("\n[1] Loading init.lua...")
local init_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)") .. "../lua/init.lua"
local vim = dofile(init_path)

assert_true(vim ~= nil, "init.lua loaded successfully")
assert_true(vim.core ~= nil, "core module exported")
assert_true(vim.submaps ~= nil, "submaps module exported")
assert_eq(_G.omarchy_vimified, vim.core, "_G.omarchy_vimified global exposed")

-- Test 2: Verify Collision Unbinds
print("\n[2] Verifying Omarchy Collision Unbinds...")
local expected_unbinds = { "SUPER + J", "SUPER + K", "SUPER + L", "SUPER + CTRL + L" }
for _, key in ipairs(expected_unbinds) do
  local found = false
  for _, unbind in ipairs(mock_unbinds) do
    if unbind == key then
      found = true
      break
    end
  end
  assert_true(found, "Unbound collision: " .. key)
end

-- Test 3: Verify HJKL Navigation Binds
print("\n[3] Verifying HJKL Navigation and Rebindings...")
local function find_bind(key)
  for _, b in ipairs(mock_binds) do
    if b.key == key then
      return b
    end
  end
  return nil
end

assert_true(find_bind("SUPER + H") ~= nil, "Bound SUPER + H (Focus Left)")
assert_true(find_bind("SUPER + J") ~= nil, "Bound SUPER + J (Focus Down)")
assert_true(find_bind("SUPER + K") ~= nil, "Bound SUPER + K (Focus Up)")
assert_true(find_bind("SUPER + L") ~= nil, "Bound SUPER + L (Focus Right)")

assert_true(find_bind("SUPER + SHIFT + H") ~= nil, "Bound SUPER + SHIFT + H (Swap Left)")
assert_true(find_bind("SUPER + SHIFT + J") ~= nil, "Bound SUPER + SHIFT + J (Swap Down)")
assert_true(find_bind("SUPER + SHIFT + K") ~= nil, "Bound SUPER + SHIFT + K (Swap Up)")
assert_true(find_bind("SUPER + SHIFT + L") ~= nil, "Bound SUPER + SHIFT + L (Swap Right)")

assert_true(find_bind("SUPER + CTRL + J") ~= nil, "Remapped SUPER + CTRL + J (Togglesplit)")
assert_true(find_bind("SUPER + CTRL + K") ~= nil, "Remapped SUPER + CTRL + K (Keybindings Menu)")
assert_true(find_bind("SUPER + CTRL + L") ~= nil, "Remapped SUPER + CTRL + L (Workspace Layout)")

assert_true(find_bind("SUPER + ALT + H") ~= nil, "Bound SUPER + ALT + H (Direct Resize Left)")
assert_true(find_bind("SUPER + ALT + J") ~= nil, "Bound SUPER + ALT + J (Direct Resize Down)")
assert_true(find_bind("SUPER + ALT + K") ~= nil, "Bound SUPER + ALT + K (Direct Resize Up)")
assert_true(find_bind("SUPER + ALT + L") ~= nil, "Bound SUPER + ALT + L (Direct Resize Right)")

-- Test 4: Verify Omarchy Shell HUD Helpers
print("\n[4] Verifying Omarchy Shell HUD IPC Helpers...")
mock_exec_cmds = {}
mock_dispatches = {}

vim.core.show_submap_cheatsheet("System")
assert_eq(
  mock_exec_cmds[1],
  "omarchy-shell shell summon omarchy-vimified '{\"submap\":\"System\"}'",
  "show_submap_cheatsheet summons HUD with correct JSON payload"
)

mock_exec_cmds = {}
vim.core.dismiss_cheatsheet()
assert_eq(
  mock_exec_cmds[1],
  "omarchy-shell shell hide omarchy-vimified",
  "dismiss_cheatsheet hides HUD"
)

mock_exec_cmds = {}
mock_dispatches = {}
vim.core.reset_submap()
assert_eq(mock_dispatches[1].name, "reset", "reset_submap resets Hyprland submap")
assert_eq(mock_exec_cmds[1], "omarchy-shell shell hide omarchy-vimified", "reset_submap hides HUD")

-- Test 5: Verify Standard Submaps Registration
print("\n[5] Verifying Standard Submaps Registration...")
local expected_submaps = {
  "Hub",
  "System",
  "Learning",
  "Programming",
  "Office",
  "IA",
  "NAV",
  "Resize",
  "Menus",
  "Reminders",
  "TTS",
  "Volume",
  "Brightness",
}

for _, sm in ipairs(expected_submaps) do
  assert_true(mock_submaps[sm] ~= nil, "Defined submap: " .. sm)
end

-- Test 6: Verify Hub and Submap Triggers
print("\n[6] Verifying Triggers (ALT + key)...")
assert_true(find_bind("ALT + RETURN") ~= nil, "Hub trigger: ALT + RETURN")
assert_true(find_bind("ALT + s") ~= nil, "System trigger: ALT + s")
assert_true(find_bind("ALT + l") ~= nil, "Learning trigger: ALT + l")
assert_true(find_bind("ALT + p") ~= nil, "Programming trigger: ALT + p")
assert_true(find_bind("ALT + o") ~= nil, "Office trigger: ALT + o")
assert_true(find_bind("ALT + i") ~= nil, "IA trigger: ALT + i")
assert_true(find_bind("ALT + n") ~= nil, "NAV trigger: ALT + n")
assert_true(find_bind("ALT + w") ~= nil, "Resize trigger: ALT + w")
assert_true(find_bind("ALT + m") ~= nil, "Menus trigger: ALT + m")
assert_true(find_bind("ALT + r") ~= nil, "Reminders trigger: ALT + r")
assert_true(find_bind("ALT + t") ~= nil, "TTS trigger: ALT + t")

-- Test 7: Verify Hub Extensibility
print("\n[7] Verifying Hub Extensibility via register_hub_target...")
local initial_count = #vim.core.hub_targets
vim.core.register_hub_target({ "u", "U" }, "UNLP")
assert_eq(#vim.core.hub_targets, initial_count + 1, "Added custom target to Hub")
assert_eq(vim.core.hub_targets[#vim.core.hub_targets].name, "UNLP", "Custom target name matches")

-- Summary
print("\n===========================================")
print(string.format("Tests Completed: %d Passed, %d Failed", passed, failed))
print("===========================================\n")

if failed > 0 then
  os.exit(1)
else
  os.exit(0)
end
