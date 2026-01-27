#!/usr/bin/env bash
set -euo pipefail

# Create/update a stable symlink pointing at Waynergy's uinput keyboard event node.
# This avoids hard-coding /dev/input/eventXX (which can change across boots).

SYMLINK_PATH="${1:-$HOME/.cache/kmonad-waynergy-kbd}"
DEVICE_NAME_REGEX="${2:-waynergy keyboard}"

mkdir -p "$(dirname "$SYMLINK_PATH")"

# Find the first matching input device block and extract its event handler.
# /proc/bus/input/devices has records separated by blank lines.
EVENT_NODE=$(
  awk -v IGNORECASE=1 -v name_re="$DEVICE_NAME_REGEX" '
    BEGIN { RS="" }
    $0 ~ "N: Name=\"" name_re "\"" {
      if (match($0, /Handlers=.*(event[0-9]+)/, m)) {
        print "/dev/input/" m[1]
        exit 0
      }
    }
  ' /proc/bus/input/devices
)

if [[ -z "${EVENT_NODE:-}" ]]; then
  echo "ERROR: could not find Waynergy keyboard event node (name regex: $DEVICE_NAME_REGEX)" >&2
  exit 1
fi

if [[ ! -e "$EVENT_NODE" ]]; then
  echo "ERROR: resolved $EVENT_NODE but it does not exist" >&2
  exit 1
fi

ln -sf "$EVENT_NODE" "$SYMLINK_PATH"

# Optional: print the resolved path for debugging
echo "$SYMLINK_PATH -> $EVENT_NODE"
