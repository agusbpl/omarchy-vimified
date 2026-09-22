# ⚡ omarchy-vimified

> **Vim-style modal submaps, HJKL window navigation and real-time cheatsheet HUD for Omarchy.**

`omarchy-vimified` es un plugin completo para sistemas **Omarchy** que transforma el flujo de trabajo de Hyprland en un entorno guiado por teclado estilo Vim. Incluye navegación direccional de ventanas con `HJKL`, submaps modales temáticos por líder (`Alt + <tecla>`), el Hub Maestro (`Alt + Enter`), y un **HUD visual interactivo en tiempo real** desarrollado nativamente en Quickshell / QML que adopta automáticamente los colores, bordes y tipografía del tema activo de Omarchy.

---

## 📸 Componentes

```text
omarchy-vimified/
├── manifest.json            # Manifiesto oficial del plugin Omarchy (kind: overlay)
├── Overlay.qml              # HUD visual Quickshell nativo con Layer Shell y cero bloqueo de input
├── SubmapsModel.js          # Catálogo completo de submaps, datos SVG inline y motor de extensión
├── install.sh               # Instalador automatizado en 1 paso para Omarchy + Hyprland
├── uninstall.sh             # Desinstalador limpio y reversible
├── lua/
│   ├── init.lua             # Entry point del módulo Lua para Hyprland
│   ├── core.lua             # Navegación HJKL, resolución de colisiones y helpers IPC
│   ├── submaps.lua          # Submaps temáticos universales y cargador dinámico
│   └── custom.lua.example   # Plantilla para ~/.config/hypr/omarchy-vimified-custom.lua
├── tests/
│   ├── test_runner.lua      # Suite de pruebas unitarias (47 tests verificados)
│   └── verify.sh            # Script de verificación integral (luac, qmllint, manifest, model)
└── README.md
```

---

## ✨ Características Principales

### 1. 🧭 Navegación Vim en Ventanas (`SUPER + H/J/K/L`)
- `SUPER + H/J/K/L`: Mover foco entre ventanas (Izquierda, Abajo, Arriba, Derecha).
- `SUPER + SHIFT + H/J/K/L`: Intercambiar posición de ventanas (*window swap*).
- **Cero conflictos:** Desvincula los atajos por defecto en colisión (`SUPER + J/K/L`) y los reasigna de manera segura a combinaciones con `CTRL`.

### 2. ⚡ Submaps Modales con HUD en Tiempo Real
Al presionar el disparador, el HUD aparece instantáneamente en la esquina superior derecha con la estética idéntica a Omarchy (fondo, bordes, insignia `ACTIVE`, badges de tecla mono y etiquetas descriptivas):

- **Master Hub ("Alt de los Alts"):** `ALT + RETURN`
- **System & Hardware:** `ALT + S`
- **Learning & Data Science:** `ALT + L` (soporte automático en 2 columnas para 26 atajos)
- **Programming & Dev:** `ALT + P`
- **Office & Docs:** `ALT + O`
- **AI & Language Models:** `ALT + I`
- **Navigation & Web:** `ALT + N`
- **Omarchy Menus:** `ALT + M`
- **Notifications & Reminders:** `ALT + R`
- **Text to Speech (TTS):** `ALT + T`
- **Volume & Brightness:** Ajustes rápidos continuos

### 3. 🎨 Independencia Tipográfica y Cero "Tofu"
- Utiliza **iconos vectoriales SVG inline** para cada categoría.
- Se adapta instantáneamente a cualquier cambio de tema con `omarchy theme set`.
- Layer Shell con `mask: Region {}` y `keyboardFocus: None`, garantizando que la superposición jamás capture clics ni interfiera con las ventanas del escritorio.

### 4. 🧩 Extensibilidad de Usuario sin Tocar el Core
Permite registrar submaps propios o scripts privados (ej. portales académicos, scripts locales de cámara o automatización):
- Archivo de usuario: `~/.config/hypr/omarchy-vimified-custom.lua`
- Registro en el Master Hub con `vim.register_hub_target({ "u", "U" }, "UNLP")`
- Atajo directo con `vim.bind_submap("U", "UNLP")`
- Soporte para submaps dinámicos en JSON en `~/.config/omarchy/submaps.json`.

---

## 🚀 Instalación y Distribución

### Método 1: Vía Repositorio Git (Recomendado para compartir)

Una vez subido a GitHub (ej: `https://github.com/<tu-usuario>/omarchy-vimified.git`):

```bash
# 1. Agregar y habilitar el plugin en Omarchy Shell
omarchy plugin add https://github.com/<tu-usuario>/omarchy-vimified.git --enable

# 2. Conectar los atajos con Hyprland
cd ~/.config/omarchy/plugins/omarchy-vimified && ./install.sh
```

### Método 2: Instalación Local Directa (Desarrollo)

Desde el directorio del proyecto:

```bash
git clone https://github.com/<tu-usuario>/omarchy-vimified.git
cd omarchy-vimified
./install.sh
```

El instalador:
1. Valida el manifiesto con `omarchy-plugin-validate`.
2. Sincroniza los archivos a `~/.config/omarchy/plugins/omarchy-vimified`.
3. Registra y activa el overlay en `omarchy-shell`.
4. Respalda e inyecta la carga del módulo en `~/.config/hypr/bindings.lua`.
5. Crea tu archivo de configuración personal inicial `~/.config/hypr/omarchy-vimified-custom.lua`.
6. Recarga Hyprland en vivo con `hyprctl reload`.

---

## 🧪 Pruebas y Verificación

El proyecto incluye un pipeline automatizado de 5 pasos:

```bash
./tests/verify.sh
```

1. **Sintaxis Lua:** Validación con `luac -p` en todos los archivos `.lua`.
2. **Entorno Simulado:** 47 pruebas unitarias con mock de compositor (colisiones, binds, swaps, IPC).
3. **Validación de Plugin:** Verificación estricta con `omarchy-plugin-validate`.
4. **Linting QML:** Inspección estricta de componentes con `qmllint`.
5. **Consistencia de Datos:** Comprobación de modelos y parsing con Node.js.

---

## 🗑️ Desinstalación

Para revertir completamente los cambios y volver al estado previo:

```bash
cd ~/.config/omarchy/plugins/omarchy-vimified
./uninstall.sh
```

---

## 👤 Autor

Desarrollado por **Agustín Barthe** para la comunidad de **Omarchy**.
Licencia MIT.
