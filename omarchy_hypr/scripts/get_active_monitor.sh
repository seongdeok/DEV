#!/usr/bin/env bash
set -euo pipefail
 
# Return active (focused) monitor name in Hyprland
# Fallbacks: activeworkspace -> cursorpos
 
# Try focused field from hyprctl monitors
ACTIVE_NAME="$(hyprctl monitors -j 2>/dev/null \
  | jq -r '.[] | select(.focused == true) | .name' | head -n1)"
 
if [[ -z "${ACTIVE_NAME}" ]]; then
  # Fallback: activeworkspace (monitor name or id may be present depending on version/setup)
  MON_FIELD="$(hyprctl activeworkspace -j 2>/dev/null \
    | jq -r '.monitor // .monitorID // empty' 2>/dev/null || true)"
 
  if [[ -n "${MON_FIELD}" ]]; then
    # Map monitor id or name to actual name
    ACTIVE_NAME="$(hyprctl monitors -j 2>/dev/null \
      | jq -r --arg m "${MON_FIELD}" '.[] | select((.name==$m) or ((.id|tostring)==$m)) | .name' | head -n1)"
  fi
fi
 
if [[ -z "${ACTIVE_NAME}" ]]; then
  # Final fallback: cursor position
  read -r CX CY < <(hyprctl cursorpos 2>/dev/null)
  ACTIVE_NAME="$(hyprctl monitors -j 2>/dev/null \
    | jq -r --argjson cx "${CX:-0}" --argjson cy "${CY:-0}" '
      .[] | select(($cx >= .x) and ($cx < (.x + .width)) and ($cy >= .y) and ($cy < (.y + .height))) | .name
    ' | head -n1)"
fi
 
if [[ -z "${ACTIVE_NAME}" ]]; then
  echo "UNKNOWN"
  exit 1
fi
 
echo "${ACTIVE_NAME}"
