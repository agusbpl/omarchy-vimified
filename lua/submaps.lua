-- omarchy-vimified: submaps.lua
-- Universal modal submaps for Omarchy Hyprland with dynamic user custom config loading

local M = {}

-- Resolve core module
local function get_core()
  if _G.omarchy_vimified then
    return _G.omarchy_vimified
  end
  local info = debug.getinfo(1, "S")
  if info and info.source and info.source:sub(1, 1) == "@" then
    local dir = info.source:sub(2):match("(.*/)") or "./"
    return dofile(dir .. "core.lua")
  end
  return require("core")
end

-- Resolve config_loader module
local function get_config_loader()
  local info = debug.getinfo(1, "S")
  if info and info.source and info.source:sub(1, 1) == "@" then
    local dir = info.source:sub(2):match("(.*/)") or "./"
    local path = dir .. "config_loader.lua"
    local f = io.open(path, "r")
    if f then
      f:close()
      return dofile(path)
    end
  end
  local ok, mod = pcall(require, "config_loader")
  if ok then return mod end
  return nil
end

local core = get_core()
local hl = _G.hl
local home = os.getenv("HOME") or ""

local submap_cmd = core.submap_cmd
local bind_submap = core.bind_submap
local reset_submap = core.reset_submap
local show_submap_cheatsheet = core.show_submap_cheatsheet

--- Register all universal standard submaps
function M.setup_standard_submaps()
  -- ---------------------------------------------------------
  -- 1. ALT + S -> System & Hardware
  -- ---------------------------------------------------------
  hl.define_submap("System", function()
    submap_cmd("f", "Files", "uwsm-app -- nautilus --new-window")
    submap_cmd("m", "Btop", "uwsm-app -- xdg-terminal-exec -e btop")
    submap_cmd("e", "Edit Binds", string.format("uwsm-app -- xdg-terminal-exec -e nvim %s/.config/hypr/bindings.lua", home))
    submap_cmd("w", "WiFi Menu", "omarchy-shell shell toggle omarchy.network")
    submap_cmd("b", "Bluetooth Menu", "omarchy-shell shell toggle omarchy.bluetooth")
    submap_cmd(
      "c",
      "Activate Camera",
      "bash -c 'if [ -f \"$HOME/Scripts/video_making/camera_activation.sh\" ]; then \"$HOME/Scripts/video_making/camera_activation.sh\"; else mpv av://v4l2:/dev/video0 --profile=low-latency --ontop --title=webcam-overlay; fi'"
    )
    submap_cmd("r", "Record Video", "omarchy-menu toggle trigger.capture.screenrecord")
    submap_cmd("s", "Screenshot", "sleep 0.08 && omarchy-capture-screenshot")
    submap_cmd("a", "Audio Settings", "omarchy-shell shell toggle omarchy.audio")
    submap_cmd("p", "Clipboard History", "omarchy-shell shell toggle omarchy.clipboard")
    submap_cmd("q", "Shutdown", "shutdown now")
    submap_cmd("n", "Nightlight Toggle", "omarchy-toggle-nightlight")
    submap_cmd("i", "Idle Lock Toggle", "omarchy-toggle-idle")
    submap_cmd("z", "Zoom Cursor", "hyprctl keyword cursor:zoom_factor 2")
    submap_cmd("d", "Display Panel", "omarchy-shell shell toggle omarchy.display")
    submap_cmd("t", "Activity Monitor", "uwsm-app -- xdg-terminal-exec -e btop")
    submap_cmd("x", "Lock Screen", "omarchy-system-lock")
    submap_cmd("k", "Power Panel", "omarchy-shell shell toggle omarchy.power")

    hl.bind("v", function()
      core.enter_child_submap("System", "Volume")
    end)
    hl.bind("l", function()
      core.enter_child_submap("System", "Brightness")
    end)
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("S", "System")

  -- ---------------------------------------------------------
  -- 2. ALT + L -> Learning & Data Science Docs
  -- ---------------------------------------------------------
  hl.define_submap("Learning", function()
    submap_cmd("c", "Cheatsheet Local", string.format("omarchy-launch-webapp 'file://%s/Scripts/cheatsheet.html'", home))
    submap_cmd("q", "Qtile Docs", "omarchy-launch-webapp 'https://docs.qtile.org/'")
    submap_cmd("b", "Bash Docs", "omarchy-launch-webapp 'https://devhints.io/bash'")
    submap_cmd("v", "Vim Docs", "omarchy-launch-webapp 'https://devhints.io/vim'")
    submap_cmd("y", "Python Docs", "omarchy-launch-webapp 'https://docs.python.org/3/'")
    submap_cmd("p", "Pandas Docs", "omarchy-launch-webapp 'https://pandas.pydata.org/docs/'")
    submap_cmd("o", "Polars Docs", "omarchy-launch-webapp 'https://docs.pola.rs/'")
    submap_cmd("m", "Matplotlib Docs", "omarchy-launch-webapp 'https://matplotlib.org/stable/contents.html'")
    submap_cmd("n", "NumPy Docs", "omarchy-launch-webapp 'https://numpy.org/doc/stable/user/quickstart.html'")
    submap_cmd("s", "Streamlit Docs", "omarchy-launch-webapp 'https://docs.streamlit.io/'")
    submap_cmd("t", "Plotly Docs", "omarchy-launch-webapp 'https://plotly.com/python/'")
    submap_cmd("l", "SQL Cheat Sheet", "omarchy-launch-webapp 'https://www.sqlshack.com/sql-cheat-sheet/'")
    submap_cmd("g", "PostgreSQL Docs", "omarchy-launch-webapp 'https://www.postgresql.org/docs/'")
    submap_cmd("d", "Data Science Menu", "omarchy-menu datascience")
    submap_cmd("a", "Airflow Docs", "omarchy-launch-webapp 'https://airflow.apache.org/docs/apache-airflow/stable/index.html'")
    submap_cmd("j", "JupyterLab Docs", "omarchy-launch-webapp 'https://jupyterlab.readthedocs.io/en/stable/'")
    submap_cmd("k", "Scikit-Learn Docs", "omarchy-launch-webapp 'https://scikit-learn.org/stable/'")
    submap_cmd("f", "PyTorch Docs", "omarchy-launch-webapp 'https://pytorch.org/docs/stable/index.html'")
    submap_cmd("e", "Metabase Docs", "omarchy-launch-webapp 'https://www.metabase.com/docs/latest/'")
    submap_cmd("w", "TensorFlow Docs", "omarchy-launch-webapp 'https://www.tensorflow.org/api_docs/python/tf'")
    submap_cmd("u", "Numba Docs", "omarchy-launch-webapp 'https://numba.readthedocs.io/en/stable/'")
    submap_cmd("i", "SciPy Docs", "omarchy-launch-webapp 'https://docs.scipy.org/doc/scipy/'")
    submap_cmd("x", "Seaborn Docs", "omarchy-launch-webapp 'https://seaborn.pydata.org/'")
    submap_cmd("z", "Hugging Face Docs", "omarchy-launch-webapp 'https://huggingface.co/docs/transformers/index'")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("L", "Learning")

  -- ---------------------------------------------------------
  -- 3. ALT + P -> Programming & Dev
  -- ---------------------------------------------------------
  hl.define_submap("Programming", function()
    submap_cmd("a", "Antigravity CLI", "uwsm-app -- xdg-terminal-exec -e agy")
    submap_cmd("c", "Google Colab", "omarchy-launch-webapp 'https://colab.research.google.com/'")
    submap_cmd("e", "Zed Editor", "zeditor")
    submap_cmd("t", "Terminal", "uwsm-app -- xdg-terminal-exec")
    submap_cmd("j", "JupyterLab", "uwsm-app -- xdg-terminal-exec -e jupyter-lab")
    submap_cmd("g", "Lazygit", "uwsm-app -- xdg-terminal-exec -e lazygit")
    submap_cmd({ "G", "SHIFT + g", "SHIFT + G" }, "GitHub Web", "omarchy-launch-webapp 'https://github.com/'")
    submap_cmd("d", "Discord", "omarchy-launch-webapp 'https://discord.com/channels/@me'")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("P", "Programming")

  -- ---------------------------------------------------------
  -- 4. ALT + O -> Office & Documents
  -- ---------------------------------------------------------
  hl.define_submap("Office", function()
    submap_cmd("n", "Obsidian", "obsidian")
    submap_cmd("o", "OnlyOffice", "onlyoffice-desktopeditors")
    submap_cmd("m", "Gmail", "omarchy-launch-webapp 'https://mail.google.com/'")
    submap_cmd("d", "Docs", "omarchy-launch-webapp 'https://docs.google.com/document/u/0/'")
    submap_cmd("s", "Sheets", "omarchy-launch-webapp 'https://docs.google.com/spreadsheets/u/0/'")
    submap_cmd("p", "Okular PDF", "okular")
    submap_cmd("z", "Zathura PDF", "zathura")
    submap_cmd("t", "DeepL Translator", "omarchy-launch-webapp 'https://www.deepl.com/en/translator'")
    submap_cmd("w", "WordReference", "omarchy-launch-webapp 'https://www.wordreference.com/definicion/'")
    submap_cmd({ "W", "SHIFT + w" }, "Wikipedia ES", "omarchy-launch-webapp 'https://es.wikipedia.org/wiki/'")
    submap_cmd("e", "Excalidraw", "omarchy-launch-webapp 'https://excalidraw.com/'")
    submap_cmd("r", "Reading Tracker", "omarchy-launch-or-focus-webapp 'Reading Tracker' 'http://readingtracker.localhost:8080'")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("O", "Office")

  -- ---------------------------------------------------------
  -- 5. ALT + I -> IA & Voice
  -- ---------------------------------------------------------
  hl.define_submap("IA", function()
    submap_cmd("v", "Voice Dictation", "voxtype record toggle")
    submap_cmd("a", "Google Gemini", "omarchy-launch-webapp 'https://gemini.google.com/app'")
    submap_cmd("c", "Claude AI", "omarchy-launch-webapp 'https://claude.ai/'")
    submap_cmd("g", "ChatGPT", "omarchy-launch-webapp 'https://chatgpt.com/'")
    submap_cmd("m", "Mistral AI", "omarchy-launch-webapp 'https://chat.mistral.ai/'")
    submap_cmd("p", "Perplexity AI", "omarchy-launch-webapp 'https://www.perplexity.ai/'")
    submap_cmd("d", "DeepSeek Chat", "omarchy-launch-webapp 'https://chat.deepseek.com/'")
    submap_cmd("k", "Kimi AI", "omarchy-launch-webapp 'https://www.kimi.com/'")
    submap_cmd("n", "NotebookLM", "omarchy-launch-webapp 'https://notebooklm.google.com/'")
    submap_cmd("o", "OpenCode TUI", "uwsm-app -- xdg-terminal-exec -e opencode")
    submap_cmd("x", "Grok AI", "omarchy-launch-webapp 'https://x.com/i/grok'")
    submap_cmd("f", "Phind AI", "omarchy-launch-webapp 'https://www.phind.com/'")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("I", "IA")

  -- ---------------------------------------------------------
  -- 6. ALT + N -> NAV (Navegación & Web)
  -- ---------------------------------------------------------
  hl.define_submap("NAV", function()
    submap_cmd("b", "Web Browser", "omarchy-launch-browser")
    submap_cmd("m", "Gmail", "omarchy-launch-webapp 'https://mail.google.com/'")
    submap_cmd("y", "YouTube", "omarchy-launch-webapp 'https://www.youtube.com'")
    submap_cmd("s", "YouTube Studio", "omarchy-launch-webapp 'https://studio.youtube.com/'")
    submap_cmd("t", "Telegram Web", "omarchy-launch-webapp 'https://web.telegram.org/a/'")
    submap_cmd("w", "WhatsApp Web", "omarchy-launch-or-focus-webapp WhatsApp 'https://web.whatsapp.com/'")
    submap_cmd("x", "X / Twitter", "omarchy-launch-webapp 'https://x.com/'")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("N", "NAV")

  -- ---------------------------------------------------------
  -- 7. ALT + M -> Menús Omarchy & Apariencia
  -- ---------------------------------------------------------
  hl.define_submap("Menus", function()
    submap_cmd("m", "Omarchy Main Menu", "omarchy-menu toggle")
    submap_cmd("a", "Apps Menu", "omarchy-menu toggle apps")
    submap_cmd("e", "Emojis Picker", "omarchy-shell shell toggle omarchy.emojis")
    submap_cmd("b", "Background Switcher", "omarchy-menu toggle background")
    submap_cmd("t", "Theme Menu", "omarchy-menu toggle theme")
    submap_cmd("s", "Share Menu", "omarchy-menu toggle share")
    submap_cmd("h", "Hardware Menu", "omarchy-menu toggle hardware")
    submap_cmd("v", "Toggle Top Bar", "omarchy-shell -q bar toggle")
    submap_cmd("k", "Keybindings Menu", "omarchy-menu-keybindings")
    submap_cmd("c", "Capture Menu", "omarchy-menu toggle trigger.capture")
    submap_cmd("r", "Herdr Keybindings", "omarchy-menu-herdr-keybindings")
    submap_cmd("q", "Calculator", "omacalc")
    submap_cmd("p", "Power Panel", "omarchy-shell shell toggle omarchy.power")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("M", "Menus")

  -- ---------------------------------------------------------
  -- 8. ALT + R -> Recordatorios & Notificaciones
  -- ---------------------------------------------------------
  hl.define_submap("Reminders", function()
    submap_cmd("d", "Dismiss Notification", "omarchy-shell notifications dismissOne")
    submap_cmd("a", "Dismiss All Notifications", "omarchy-shell notifications dismissAll")
    submap_cmd("s", "Silence Notifications", "omarchy-shell notifications toggleSilence")
    submap_cmd("h", "Notification History", "omarchy-shell notifications showHistory")
    submap_cmd("n", "Set Reminder", "omarchy-menu toggle reminder-set")
    submap_cmd("v", "Show Reminders", "omarchy-reminder show")
    submap_cmd("c", "Clear Reminders", "omarchy-reminder clear")
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("R", "Reminders")

  -- ---------------------------------------------------------
  -- 9. ALT + T -> TTS (Text to Speech)
  -- ---------------------------------------------------------
  hl.define_submap("TTS", function()
    submap_cmd(
      "p",
      "Piper TTS ES",
      "bash -c 'pc=$(hostname | grep -qi hostgus && echo 1 || echo 0); [ -f \"$HOME/Scripts/piper_say$pc.sh\" ] && \"$HOME/Scripts/piper_say$pc.sh\"'"
    )
    submap_cmd(
      "e",
      "Piper TTS EN",
      "bash -c '[ -f \"$HOME/Scripts/piper_say_en.sh\" ] && \"$HOME/Scripts/piper_say_en.sh\"'"
    )
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("T", "TTS")

  -- ---------------------------------------------------------
  -- 10. Hardware Submaps (Volume & Brightness)
  -- ---------------------------------------------------------
  hl.define_submap("Volume", function()
    hl.bind("k", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") end, { repeat_trigger = true })
    hl.bind("K", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") end, { repeat_trigger = true })
    hl.bind("j", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") end, { repeat_trigger = true })
    hl.bind("J", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") end, { repeat_trigger = true })
    submap_cmd("m", "Mute Toggle", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    hl.bind("ESCAPE", reset_submap)
  end)

  hl.define_submap("Brightness", function()
    hl.bind("k", function()
      hl.exec_cmd("bash -c 'if (( $(brightnessctl get) <= 4800 )); then brightnessctl set 1%+; else brightnessctl set 5%+; fi'")
    end, { repeat_trigger = true })
    hl.bind("K", function()
      hl.exec_cmd("bash -c 'if (( $(brightnessctl get) <= 4800 )); then brightnessctl set 1%+; else brightnessctl set 5%+; fi'")
    end, { repeat_trigger = true })
    hl.bind("j", function()
      hl.exec_cmd("bash -c 'if (( $(brightnessctl get) <= 4800 )); then brightnessctl set 1%-; else brightnessctl set 5%-; fi'")
    end, { repeat_trigger = true })
    hl.bind("J", function()
      hl.exec_cmd("bash -c 'if (( $(brightnessctl get) <= 4800 )); then brightnessctl set 1%-; else brightnessctl set 5%-; fi'")
    end, { repeat_trigger = true })
    hl.bind("ESCAPE", reset_submap)
  end)

  -- ---------------------------------------------------------
  -- 11b. ALT + F -> Frames (Unified Window Management)
  -- ---------------------------------------------------------
  hl.define_submap("Frames", function()
    -- Fullscreen variants
    hl.bind("f", function()
      reset_submap()
      if hl.dsp and hl.dsp.window and hl.dsp.window.fullscreen then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
      else
        hl.exec_cmd("hyprctl dispatch fullscreen 0")
      end
    end, { description = "Fullscreen" })

    submap_cmd("F", "Tiled Fullscreen", "omarchy-hyprland-window-tiled-fullscreen-toggle")

    hl.bind("m", function()
      reset_submap()
      if hl.dsp and hl.dsp.window and hl.dsp.window.fullscreen then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized" }))
      else
        hl.exec_cmd("hyprctl dispatch fullscreen 2")
      end
    end, { description = "Maximized" })

    -- Window state toggles
    hl.bind("t", function()
      reset_submap()
      if hl.dsp and hl.dsp.window and hl.dsp.window.float then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
      else
        hl.exec_cmd("hyprctl dispatch togglefloating")
      end
    end, { description = "Toggle Float/Tile" })

    hl.bind("p", function()
      reset_submap()
      if hl.dsp and hl.dsp.window and hl.dsp.window.pseudo then
        hl.dispatch(hl.dsp.window.pseudo())
      else
        hl.exec_cmd("hyprctl dispatch pseudo")
      end
    end, { description = "Pseudo Tile" })

    submap_cmd("o", "Pop Out (Float & Pin)", "omarchy-hyprland-window-pop")

    hl.bind("s", function()
      reset_submap()
      if hl.dsp and hl.dsp.layout then
        hl.dispatch(hl.dsp.layout("togglesplit"))
      else
        hl.exec_cmd("hyprctl dispatch togglesplit")
      end
    end, { description = "Toggle Split" })

    -- Window groups
    hl.bind("g", function()
      reset_submap()
      if hl.dsp and hl.dsp.group and hl.dsp.group.toggle then
        hl.dispatch(hl.dsp.group.toggle())
      else
        hl.exec_cmd("hyprctl dispatch togglegroup")
      end
    end, { description = "Toggle Group" })

    hl.bind("G", function()
      reset_submap()
      if hl.dsp and hl.dsp.window and hl.dsp.window.move then
        hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
      else
        hl.exec_cmd("hyprctl dispatch moveoutofgroup")
      end
    end, { description = "Move Out of Group" })

    -- Width presets
    submap_cmd("w", "Save Width", "omarchy-hyprland-window-width save")
    submap_cmd("r", "Restore Width", "omarchy-hyprland-window-width restore")

    -- System Lock (restored — was displaced from SUPER+CTRL+L)
    submap_cmd("l", "Lock Screen", "omarchy-system-lock")

    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("F", "Frames")

  -- ---------------------------------------------------------
  -- 11. Window Resize (Quick Adjust) -> ALT + D
  -- ---------------------------------------------------------
  hl.define_submap("Resize", function()
    local step = 10
    local step_big = 30

    local function resize_action(dx, dy)
      if hl.dsp and hl.dsp.window and hl.dsp.window.resize then
        return hl.dsp.window.resize({ x = dx, y = dy, relative = true })
      else
        return function() hl.exec_cmd(string.format("hyprctl dispatch resizeactive %d %d", dx, dy)) end
      end
    end

    -- Fine micro-adjustments (h, j, k, l): 10px
    hl.bind("h", resize_action(-step, 0), { repeat_trigger = true })
    hl.bind("l", resize_action(step, 0), { repeat_trigger = true })
    hl.bind("j", resize_action(0, step), { repeat_trigger = true })
    hl.bind("k", resize_action(0, -step), { repeat_trigger = true })

    -- Coarse adjustments (H, J, K, L): 30px
    hl.bind("H", resize_action(-step_big, 0), { repeat_trigger = true })
    hl.bind("L", resize_action(step_big, 0), { repeat_trigger = true })
    hl.bind("J", resize_action(0, step_big), { repeat_trigger = true })
    hl.bind("K", resize_action(0, -step_big), { repeat_trigger = true })

    -- Save / Restore width presets
    submap_cmd("s", "Save Width", "omarchy-hyprland-window-width save")
    submap_cmd("r", "Restore Width", "omarchy-hyprland-window-width restore")

    -- Exit submap
    hl.bind("RETURN", reset_submap)
    hl.bind("ESCAPE", reset_submap)
  end)
  bind_submap("D", "Resize")
end

--- Load user custom configuration if it exists (~/.config/hypr/omarchy-vimified-custom.lua)
function M.load_user_custom_config()
  local custom_path = home .. "/.config/hypr/omarchy-vimified-custom.lua"
  local f = io.open(custom_path, "r")
  if f then
    f:close()
    local chunk, load_err = loadfile(custom_path)
    if chunk then
      local ok, run_err = pcall(chunk)
      if not ok then
        local msg = "Error executing omarchy-vimified-custom.lua: " .. tostring(run_err)
        if hl and hl.exec_cmd then
          hl.exec_cmd(string.format("omarchy-notification-send -u normal 'omarchy-vimified' %q", msg))
        end
      end
    else
      local msg = "Syntax error in omarchy-vimified-custom.lua: " .. tostring(load_err)
      if hl and hl.exec_cmd then
        hl.exec_cmd(string.format("omarchy-notification-send -u critical 'omarchy-vimified' %q", msg))
      end
    end
  end
end

--- Setup Master Hub (ALT + RETURN) combining standard and custom submaps
function M.setup_hub()
  hl.define_submap("Hub", function()
    for _, item in ipairs(core.hub_targets) do
      for _, k in ipairs(item.keys) do
        hl.bind(k, function()
          show_submap_cheatsheet(item.name)
          hl.dispatch(hl.dsp.submap(item.name))
        end)
      end
    end

    hl.bind("ESCAPE", reset_submap)
    hl.bind("RETURN", reset_submap)
  end)

  hl.bind("ALT + RETURN", function()
    show_submap_cheatsheet("Hub")
    hl.dispatch(hl.dsp.submap("Hub"))
  end)
end

--- Complete setup: standard submaps -> declarative config -> imperative custom config -> master hub
function M.setup()
  M.setup_standard_submaps()
  local loader = get_config_loader()
  if loader and loader.load_declarative_config then
    loader.load_declarative_config(core)
  end
  M.load_user_custom_config()
  M.setup_hub()
end

M.setup()

return M
