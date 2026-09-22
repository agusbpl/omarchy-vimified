#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=== Verifying omarchy-vimified Lua codebase in $DIR ==="

echo "1. Checking Lua syntax with luac..."
for f in "$DIR"/lua/*.lua "$DIR"/lua/*.example "$DIR"/tests/*.lua; do
  if [ -f "$f" ]; then
    echo -n "  Checking $(basename "$f")... "
    luac -p "$f"
    echo -e "\033[32mOK\033[0m"
  fi
done

echo ""
echo "2. Running unit tests with mock compositor environment..."
lua "$DIR/tests/test_runner.lua"

echo ""
echo "3. Validating plugin manifest..."
omarchy-plugin-validate "$DIR"
echo -e "\033[32mmanifest.json is 100% valid Omarchy plugin manifest\033[0m"

echo ""
echo "4. Linting QML components..."
if command -v qmllint >/dev/null 2>&1; then
  qmllint -I /usr/share/omarchy/shell "$DIR/Overlay.qml"
  echo -e "\033[32mOverlay.qml passed qmllint\033[0m"
fi

echo ""
echo "5. Verifying SubmapsModel.js logic..."
node -e 'const fs = require("fs"); const code = fs.readFileSync("'"$DIR"'/SubmapsModel.js", "utf8").replace(".pragma library", "// .pragma library"); eval(code); if (!getSubmap("Hub").entries.length || !getSubmap("Learning").entries.length) process.exit(1);'
echo -e "\033[32mSubmapsModel.js is valid and verified\033[0m"

echo ""
echo -e "\033[32mAll verification checks passed successfully!\033[0m"

