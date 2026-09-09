#!/usr/bin/env bash
# Headless import + boot smoke for Godot 4.7.x (Arena Dodger).
# Usage: ./scripts/smoke.sh
# Optional: GODOT_BIN=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./scripts/smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

resolve_godot() {
  if [[ -n "${GODOT_BIN:-}" ]]; then
    if [[ -x "$GODOT_BIN" ]] || command -v "$GODOT_BIN" >/dev/null 2>&1; then
      echo "$GODOT_BIN"
      return 0
    fi
    echo "error: GODOT_BIN is set but not executable: $GODOT_BIN" >&2
    return 1
  fi

  local candidate
  for candidate in godot4 godot Godot; do
    if command -v "$candidate" >/dev/null 2>&1; then
      echo "$candidate"
      return 0
    fi
  done

  echo "error: Godot 4.7.x not found. Install Godot 4.7.2 and set GODOT_BIN, or add godot/godot4 to PATH." >&2
  return 1
}

GODOT="$(resolve_godot)"

echo "==> Using Godot binary: $GODOT"
echo "==> Project root: $ROOT"

# Print version (best-effort; do not fail if flag quirks differ).
if ! "$GODOT" --version 2>/dev/null; then
  "$GODOT" --help >/dev/null 2>&1 || true
fi

echo "==> Importing project (headless)..."
"$GODOT" --headless --path "$ROOT" --import --quit-after 1

echo "==> Booting main scene (headless, short run)..."
# Quit after a few frames so _ready runs without needing a display.
"$GODOT" --headless --path "$ROOT" --quit-after 30

echo "==> Smoke OK"
exit 0
