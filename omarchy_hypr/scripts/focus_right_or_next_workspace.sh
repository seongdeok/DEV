#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   focus_right_or_next_workspace.sh r|right
#   focus_right_or_next_workspace.sh l|left
#
# Behavior:
# 1) Try to focus the window in the requested direction (hyprctl dispatch movefocus <dir>)
# 2) If focus didn't change, switch workspace on this monitor (m+1 for right, m-1 for left)
# 3) Focus an edge window on the new workspace (leftmost for right, rightmost for left)

if ! command -v hyprctl >/dev/null 2>&1; then
  exit 0
fi

dir_raw="${1:-r}"
case "$dir_raw" in
  r|right|R|Right) dir="r"; ws_delta="m+1"; edge="left" ;;
  l|left|L|Left)  dir="l"; ws_delta="m-1"; edge="right" ;;
  *)
    # Unknown arg -> default to right
    dir="r"; ws_delta="m+1"; edge="left"
    ;;
esac

has_jq=0
if command -v jq >/dev/null 2>&1; then
  has_jq=1
fi

get_active_addr() {
  if [[ "$has_jq" -eq 1 ]]; then
    hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty'
  else
    # Fallback: best-effort parse. If this fails, we treat it as "unchanged".
    hyprctl activewindow 2>/dev/null | awk -F': ' '/^address:/{print $2; exit}'
  fi
}

before_addr="$(get_active_addr)"

# If we can't determine the active window, just do a plain focus move.
if [[ -z "$before_addr" ]]; then
  hyprctl dispatch movefocus "$dir" >/dev/null 2>&1 || true
  exit 0
fi

# Try regular focus move first
hyprctl dispatch movefocus "$dir" >/dev/null 2>&1 || true
sleep 0.02

after_addr="$(get_active_addr)"

if [[ -z "$after_addr" ]]; then
  exit 0
fi

# If focus changed, we're done.
if [[ "$before_addr" != "$after_addr" ]]; then
  exit 0
fi

# No window in that direction: move to the adjacent workspace on the current monitor.
hyprctl dispatch workspace "$ws_delta" >/dev/null 2>&1 || exit 0
sleep 0.05

# If jq isn't available, we can't reliably pick the leftmost client.
if [[ "$has_jq" -ne 1 ]]; then
  exit 0
fi

ws_id="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')"
if [[ -z "$ws_id" ]]; then
  exit 0
fi

leftmost_addr="$(
  hyprctl clients -j 2>/dev/null \
  | jq -r --argjson ws "$ws_id" --arg edge "$edge" '
      map(select(.mapped == true))
      | map(select(.hidden != true))
      | map(select(.workspace.id == $ws))
      | sort_by(.at[0])
      | if length == 0 then empty
        elif $edge == "left" then .[0].address
        else .[-1].address
        end
    '
)"

if [[ -n "$leftmost_addr" ]]; then
  hyprctl dispatch focuswindow "address:$leftmost_addr" >/dev/null 2>&1 || true
fi
