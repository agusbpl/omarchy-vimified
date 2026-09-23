.pragma library

// omarchy-vimified: SubmapsModel.js
// Submaps catalog and data model for Omarchy Vimified overlay HUD

var SVG_ICONS = {
  "Hub": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolygon%20points%3D%2213%202%203%2014%2012%2014%2011%2022%2021%2010%2012%2010%2013%202%22%3E%3C/polygon%3E%3C/svg%3E",
  "System": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Ccircle%20cx%3D%2212%22%20cy%3D%2212%22%20r%3D%223%22%3E%3C/circle%3E%3Cpath%20d%3D%22M19.4%2015a1.65%201.65%200%200%200%20.33%201.82l.06.06a2%202%200%200%201%200%202.83%202%202%200%200%201-2.83%200l-.06-.06a1.65%201.65%200%200%200-1.82-.33%201.65%201.65%200%200%200-1%201.51V21a2%202%200%200%201-2%202%202%202%200%200%201-2-2v-.09A1.65%201.65%200%200%200%209%2019.4a1.65%201.65%200%200%200-1.82.33l-.06.06a2%202%200%200%201-2.83%200%202%202%200%200%201%200-2.83l.06-.06a1.65%201.65%200%200%200%20.33-1.82%201.65%201.65%200%200%200-1.51-1H3a2%202%200%200%201-2-2%202%202%200%200%201%202-2h.09A1.65%201.65%200%200%200%204.6%209a1.65%201.65%200%200%200-.33-1.82l-.06-.06a2%202%200%200%201%200-2.83%202%202%200%200%201%202.83%200l.06.06a1.65%201.65%200%200%200%201.82.33H9a1.65%201.65%200%200%200%201-1.51V3a2%202%200%200%201%202-2%202%202%200%200%201%202%202v.09a1.65%201.65%200%200%200%201%201.51%201.65%201.65%200%200%200%201.82-.33l.06-.06a2%202%200%200%201%202.83%200%202%202%200%200%201%200%202.83l-.06.06a1.65%201.65%200%200%200-.33%201.82V9a1.65%201.65%200%200%200%201.51%201H21a2%202%200%200%201%202%202%202%202%200%200%201-2%202h-.09a1.65%201.65%200%200%200-1.51%201z%22%3E%3C/path%3E%3C/svg%3E",
  "Learning": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M4%2019.5A2.5%202.5%200%200%201%206.5%2017H20%22%3E%3C/path%3E%3Cpath%20d%3D%22M6.5%202H20v20H6.5A2.5%202.5%200%200%201%204%2019.5v-15A2.5%202.5%200%200%201%206.5%202z%22%3E%3C/path%3E%3C/svg%3E",
  "Programming": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolyline%20points%3D%224%2017%2010%2011%204%205%22%3E%3C/polyline%3E%3Cline%20x1%3D%2212%22%20y1%3D%2219%22%20x2%3D%2220%22%20y2%3D%2219%22%3E%3C/line%3E%3C/svg%3E",
  "Office": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M14%202H6a2%202%200%200%200-2%202v16a2%202%200%200%200%202%202h12a2%202%200%200%200%202-2V8z%22%3E%3C/path%3E%3Cpolyline%20points%3D%2214%202%2014%208%2020%208%22%3E%3C/polyline%3E%3Cline%20x1%3D%2216%22%20y1%3D%2213%22%20x2%3D%228%22%20y2%3D%2213%22%3E%3C/line%3E%3Cline%20x1%3D%2216%22%20y1%3D%2217%22%20x2%3D%228%22%20y2%3D%2217%22%3E%3C/line%3E%3Cpolyline%20points%3D%2210%209%209%209%208%209%22%3E%3C/polyline%3E%3C/svg%3E",
  "IA": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Crect%20x%3D%224%22%20y%3D%224%22%20width%3D%2216%22%20height%3D%2216%22%20rx%3D%222%22%3E%3C/rect%3E%3Crect%20x%3D%229%22%20y%3D%229%22%20width%3D%226%22%20height%3D%226%22%3E%3C/rect%3E%3Cline%20x1%3D%229%22%20y1%3D%221%22%20x2%3D%229%22%20y2%3D%224%22%3E%3C/line%3E%3Cline%20x1%3D%2215%22%20y1%3D%221%22%20x2%3D%2215%22%20y2%3D%224%22%3E%3C/line%3E%3Cline%20x1%3D%229%22%20y1%3D%2220%22%20x2%3D%229%22%20y2%3D%2223%22%3E%3C/line%3E%3Cline%20x1%3D%2215%22%20y1%3D%2220%22%20x2%3D%2215%22%20y2%3D%2223%22%3E%3C/line%3E%3Cline%20x1%3D%2220%22%20y1%3D%229%22%20x2%3D%2223%22%20y2%3D%229%22%3E%3C/line%3E%3Cline%20x1%3D%2220%22%20y1%3D%2214%22%20x2%3D%2223%22%20y2%3D%2214%22%3E%3C/line%3E%3Cline%20x1%3D%221%22%20y1%3D%229%22%20x2%3D%224%22%20y2%3D%229%22%3E%3C/line%3E%3Cline%20x1%3D%221%22%20y1%3D%2214%22%20x2%3D%224%22%20y2%3D%2214%22%3E%3C/line%3E%3C/svg%3E",
  "NAV": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Ccircle%20cx%3D%2212%22%20cy%3D%2212%22%20r%3D%2210%22%3E%3C/circle%3E%3Cline%20x1%3D%222%22%20y1%3D%2212%22%20x2%3D%2222%22%20y2%3D%2212%22%3E%3C/line%3E%3Cpath%20d%3D%22M12%202a15.3%2015.3%200%200%201%204%2010%2015.3%2015.3%200%200%201-4%2010%2015.3%2015.3%200%200%201-4-10%2015.3%2015.3%200%200%201%204-10z%22%3E%3C/path%3E%3C/svg%3E",
  "UNLP": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M22%2010v6M2%2010l10-5%2010%205-10%205z%22%3E%3C/path%3E%3Cpath%20d%3D%22M6%2012v5c3%203%209%203%2012%200v-5%22%3E%3C/path%3E%3C/svg%3E",
  "Menus": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Ccircle%20cx%3D%2213.5%22%20cy%3D%226.5%22%20r%3D%22.5%22%3E%3C/circle%3E%3Ccircle%20cx%3D%2217.5%22%20cy%3D%2210.5%22%20r%3D%22.5%22%3E%3C/circle%3E%3Ccircle%20cx%3D%228.5%22%20cy%3D%227.5%22%20r%3D%22.5%22%3E%3C/circle%3E%3Ccircle%20cx%3D%226.5%22%20cy%3D%2212.5%22%20r%3D%22.5%22%3E%3C/circle%3E%3Cpath%20d%3D%22M12%202C6.5%202%202%206.5%202%2012s4.5%2010%2010%2010c.926%200%201.648-.746%201.648-1.688%200-.437-.18-.835-.437-1.125-.29-.289-.438-.652-.438-1.125a1.64%201.64%200%200%201%201.668-1.668h1.996c3.051%200%205.555-2.503%205.555-5.554C21.965%206.012%2017.461%202%2012%202z%22%3E%3C/path%3E%3C/svg%3E",
  "Reminders": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M18%208A6%206%200%200%200%206%208c0%207-3%209-3%209h18s-3-2-3-9%22%3E%3C/path%3E%3Cpath%20d%3D%22M13.73%2021a2%202%200%200%201-3.46%200%22%3E%3C/path%3E%3C/svg%3E",
  "TTS": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M12%201a3%203%200%200%200-3%203v8a3%203%200%200%200%206%200V4a3%203%200%200%200-3-3z%22%3E%3C/path%3E%3Cpath%20d%3D%22M19%2010v2a7%207%200%200%201-14%200v-2%22%3E%3C/path%3E%3Cline%20x1%3D%2212%22%20y1%3D%2219%22%20x2%3D%2212%22%20y2%3D%2223%22%3E%3C/line%3E%3Cline%20x1%3D%228%22%20y1%3D%2223%22%20x2%3D%2216%22%20y2%3D%2223%22%3E%3C/line%3E%3C/svg%3E",
  "Volume": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolygon%20points%3D%2211%205%206%209%202%209%202%2015%206%2015%2011%2019%2011%205%22%3E%3C/polygon%3E%3Cpath%20d%3D%22M19.07%204.93a10%2010%200%200%201%200%2014.14M15.54%208.46a5%205%200%200%201%200%207.07%22%3E%3C/path%3E%3C/svg%3E",
  "Brightness": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Ccircle%20cx%3D%2212%22%20cy%3D%2212%22%20r%3D%225%22%3E%3C/circle%3E%3Cline%20x1%3D%2212%22%20y1%3D%221%22%20x2%3D%2212%22%20y2%3D%223%22%3E%3C/line%3E%3Cline%20x1%3D%2212%22%20y1%3D%2221%22%20x2%3D%2212%22%20y2%3D%2223%22%3E%3C/line%3E%3Cline%20x1%3D%224.22%22%20y1%3D%224.22%22%20x2%3D%225.64%22%20y2%3D%225.64%22%3E%3C/line%3E%3Cline%20x1%3D%2218.36%22%20y1%3D%2218.36%22%20x2%3D%2219.78%22%20y2%3D%2219.78%22%3E%3C/line%3E%3Cline%20x1%3D%221%22%20y1%3D%2212%22%20x2%3D%223%22%20y2%3D%2212%22%3E%3C/line%3E%3Cline%20x1%3D%2221%22%20y1%3D%2212%22%20x2%3D%2223%22%20y2%3D%2212%22%3E%3C/line%3E%3Cline%20x1%3D%224.22%22%20y1%3D%2219.78%22%20x2%3D%225.64%22%20y2%3D%2218.36%22%3E%3C/line%3E%3Cline%20x1%3D%2218.36%22%20y1%3D%225.64%22%20x2%3D%2219.78%22%20y2%3D%224.22%22%3E%3C/line%3E%3C/svg%3E",
  "Resize": "data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%237aa2f7%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M15%203h6v6M9%2021H3v-6M21%203l-7%207M3%2021l7-7%22%3E%3C/path%3E%3C/svg%3E"
};

var DEFAULT_SUBMAPS = {
  "Hub": {
    "icon": "⚡",
    "iconSvg": SVG_ICONS["Hub"],
    "title": "Alt Hub",
    "tag": "MASTER SUBMAP [ALT + ENTER]",
    "entries": [
      ["s", "+System"],
      ["l", "+Learning"],
      ["p", "+Programming"],
      ["o", "+Office"],
      ["i", "+AI"],
      ["n", "+Navigation"],
      ["d", "+Resize (Dims)..."],
      ["u", "+UNLP"],
      ["m", "+Menus"],
      ["r", "+Reminders"],
      ["t", "+TTS"],
      ["v", "+Volume..."],
      ["b", "+Brightness..."]
    ]
  },
  "System": {
    "icon": "⚙️",
    "iconSvg": SVG_ICONS["System"],
    "title": "System",
    "tag": "SUBMAP [ALT + S]",
    "entries": [
      ["f", "Files (Nautilus)"],
      ["m", "Btop System Monitor"],
      ["e", "Edit Binds (Neovim)"],
      ["w", "WiFi Network Menu"],
      ["b", "Bluetooth Devices"],
      ["c", "Activate Camera"],
      ["r", "Record Video"],
      ["s", "Screenshot"],
      ["a", "Audio Settings"],
      ["p", "Clipboard History"],
      ["q", "Shutdown System"],
      ["v", "+Volume Control..."],
      ["l", "+Brightness Control..."]
    ]
  },
  "Learning": {
    "icon": "📚",
    "iconSvg": SVG_ICONS["Learning"],
    "title": "Learning",
    "tag": "SUBMAP [ALT + L]",
    "entries": [
      ["c", "Cheatsheet Local"],
      ["q", "Qtile Docs"],
      ["b", "Bash Docs"],
      ["v", "Vim Docs"],
      ["y", "Python Docs"],
      ["p", "Pandas Docs"],
      ["o", "Polars Docs"],
      ["m", "Matplotlib Docs"],
      ["n", "NumPy Docs"],
      ["s", "Streamlit Docs"],
      ["t", "Plotly Docs"],
      ["l", "SQL Cheat Sheet"],
      ["g", "PostgreSQL Docs"],
      ["d", "Data Science Menu"],
      ["a", "Airflow Docs"],
      ["r", "Relax RelAlg"],
      ["h", "OpenStax Biology"],
      ["j", "JupyterLab Docs"],
      ["k", "Scikit-Learn Docs"],
      ["f", "PyTorch Docs"],
      ["e", "Metabase Docs"],
      ["w", "TensorFlow Docs"],
      ["u", "Numba Docs"],
      ["i", "SciPy Docs"],
      ["x", "Seaborn Docs"],
      ["z", "Hugging Face Docs"]
    ]
  },
  "Programming": {
    "icon": "💻",
    "iconSvg": SVG_ICONS["Programming"],
    "title": "Programming",
    "tag": "SUBMAP [ALT + P]",
    "entries": [
      ["a", "Antigravity CLI"],
      ["c", "Google Colab"],
      ["e", "Zed Editor"],
      ["t", "Terminal"],
      ["j", "JupyterLab"],
      ["g", "Lazygit"],
      ["Shift+g", "GitHub Web"],
      ["d", "Discord"]
    ]
  },
  "Office": {
    "icon": "📝",
    "iconSvg": SVG_ICONS["Office"],
    "title": "Office",
    "tag": "SUBMAP [ALT + O]",
    "entries": [
      ["n", "Obsidian"],
      ["o", "OnlyOffice"],
      ["m", "Gmail"],
      ["d", "Docs"],
      ["s", "Sheets"],
      ["p", "Okular PDF"],
      ["z", "Zathura PDF"],
      ["t", "DeepL Translator"],
      ["w", "WordReference"],
      ["Shift+w", "Wikipedia ES"],
      ["e", "Excalidraw"],
      ["r", "Reading Tracker"]
    ]
  },
  "IA": {
    "icon": "🤖",
    "iconSvg": SVG_ICONS["IA"],
    "title": "AI",
    "tag": "SUBMAP [ALT + I]",
    "entries": [
      ["v", "Voice Dictation"],
      ["a", "Google Gemini"],
      ["c", "Claude AI"],
      ["g", "ChatGPT"],
      ["m", "Google Gemini"],
      ["p", "Perplexity AI"],
      ["d", "DeepSeek Chat"],
      ["k", "Kimi AI"],
      ["n", "NotebookLM"],
      ["o", "OpenCode TUI"],
      ["x", "Grok AI"],
      ["f", "Phind AI"]
    ]
  },
  "NAV": {
    "icon": "🌐",
    "iconSvg": SVG_ICONS["NAV"],
    "title": "Navigation",
    "tag": "SUBMAP [ALT + N]",
    "entries": [
      ["b", "Web Browser"],
      ["m", "Gmail"],
      ["y", "YouTube"],
      ["s", "YouTube Studio"],
      ["t", "Telegram Web"],
      ["w", "WhatsApp Web"],
      ["x", "X / Twitter"]
    ]
  },
  "UNLP": {
    "icon": "🎓",
    "iconSvg": SVG_ICONS["UNLP"],
    "title": "UNLP University",
    "tag": "SUBMAP [ALT + U]",
    "entries": [
      ["a", "AU24 Económicas"],
      ["l", "Cátedras LINTI"],
      ["i", "IDEAS Informática"],
      ["m", "Asignaturas Moodle"]
    ]
  },
  "Menus": {
    "icon": "🎨",
    "iconSvg": SVG_ICONS["Menus"],
    "title": "Menus",
    "tag": "SUBMAP [ALT + M]",
    "entries": [
      ["m", "Omarchy Main Menu"],
      ["a", "Apps Menu"],
      ["e", "Emojis Picker"],
      ["b", "Background Switcher"],
      ["t", "Theme Menu"],
      ["s", "Share Menu"],
      ["h", "Hardware Menu"],
      ["v", "Toggle Top Bar"],
      ["k", "Keybindings Menu"]
    ]
  },
  "Reminders": {
    "icon": "🔔",
    "iconSvg": SVG_ICONS["Reminders"],
    "title": "Reminders",
    "tag": "SUBMAP [ALT + R]",
    "entries": [
      ["d", "Dismiss Notification"],
      ["a", "Dismiss All Notifications"],
      ["s", "Silence Notifications"],
      ["h", "Notification History"],
      ["n", "Set Reminder"],
      ["v", "Show Reminders"],
      ["c", "Clear Reminders"]
    ]
  },
  "TTS": {
    "icon": "🗣️",
    "iconSvg": SVG_ICONS["TTS"],
    "title": "TTS",
    "tag": "SUBMAP [ALT + T]",
    "entries": [
      ["p", "Piper TTS ES"],
      ["e", "Piper TTS EN"]
    ]
  },
  "Volume": {
    "icon": "🔊",
    "iconSvg": SVG_ICONS["Volume"],
    "title": "Volume Control",
    "tag": "QUICK ADJUST",
    "entries": [
      ["k / K", "+5% Volume Up"],
      ["j / J", "-5% Volume Down"],
      ["m", "Mute Toggle"]
    ]
  },
  "Brightness": {
    "icon": "☀️",
    "iconSvg": SVG_ICONS["Brightness"],
    "title": "Brightness Control",
    "tag": "QUICK ADJUST",
    "entries": [
      ["k / K", "Brightness Up"],
      ["j / J", "Brightness Down"]
    ]
  },
  "Resize": {
    "icon": "📐",
    "iconSvg": SVG_ICONS["Resize"],
    "title": "Window Resize",
    "tag": "SUBMAP [ALT + D]",
    "entries": [
      ["h / l", "Width (-/+ 30px)"],
      ["j / k", "Height (+/- 30px)"],
      ["H / L", "Width Fast (-/+ 90px)"],
      ["J / K", "Height Fast (+/- 90px)"],
      ["s", "Save Width"],
      ["r", "Restore Width"]
    ]
  }
};

// User-provided runtime/configuration overrides
var userOverrides = {};

function setUserConfig(configOrJson) {
  if (!configOrJson) {
    userOverrides = {};
    return;
  }
  if (typeof configOrJson === "string") {
    try {
      userOverrides = JSON.parse(configOrJson);
    } catch (e) {
      console.warn("SubmapsModel: failed to parse user config JSON:", e);
      userOverrides = {};
    }
  } else if (typeof configOrJson === "object") {
    userOverrides = configOrJson;
  }
}

function registerSubmap(name, data) {
  if (name && data) {
    userOverrides[name] = data;
  }
}

function normalizeSubmap(name, raw) {
  var icon = raw.icon || "⚡";
  var iconSvg = raw.iconSvg || SVG_ICONS[name] || SVG_ICONS["Hub"];
  return {
    name: name,
    title: raw.title || ("Submap: " + name),
    tag: raw.tag || ("SUBMAP [" + name.toUpperCase() + "]"),
    icon: icon,
    iconSvg: iconSvg,
    entries: Array.isArray(raw.entries) ? raw.entries : []
  };
}

function getSubmap(name, dynamicOverrides) {
  var target = name || "Hub";
  if (dynamicOverrides && dynamicOverrides[target]) {
    return normalizeSubmap(target, dynamicOverrides[target]);
  }
  if (userOverrides && userOverrides[target]) {
    return normalizeSubmap(target, userOverrides[target]);
  }
  if (DEFAULT_SUBMAPS[target]) {
    return normalizeSubmap(target, DEFAULT_SUBMAPS[target]);
  }
  return {
    name: target,
    title: "Submap: " + target,
    tag: "SUBMAP [" + target.toUpperCase() + "]",
    icon: "⚡",
    iconSvg: SVG_ICONS["Hub"],
    entries: []
  };
}

function getAllSubmapNames() {
  var names = [];
  for (var k in DEFAULT_SUBMAPS) {
    if (names.indexOf(k) === -1) names.push(k);
  }
  for (var u in userOverrides) {
    if (names.indexOf(u) === -1) names.push(u);
  }
  return names;
}

function calcKeyWidth(entries) {
  var maxW = 26;
  if (!entries || !Array.isArray(entries)) return maxW;
  for (var i = 0; i < entries.length; i++) {
    var item = entries[i];
    var k = item && item[0] ? String(item[0]) : "";
    var w = Math.max(26, k.length * 8 + 14);
    if (w > maxW) maxW = w;
  }
  return maxW;
}
