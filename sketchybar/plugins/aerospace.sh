#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

echo "CHANGED $1 $2 $INFO"

if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on \
                            background.color=$ACCENT_COLOR \
                            label.color=$BAR_COLOR \
                            icon.color=$BAR_COLOR
else
    sketchybar --set $NAME background.drawing=off \
                            label.color=$ACCENT_COLOR\
                            icon.color=$ACCENT_COLOR
fi

label=""
while IFS='|' read -r app title; do
  app_icon=$(~/dotfiles/sketchybar/plugins/icon_map_fn.sh "$app")
  label+="$app_icon"
done < <(aerospace list-windows --workspace "$1" --format "%{app-name}|%{window-title}")
if [ -z "$label" ]; then
  label=":close:"
fi

sketchybar --set workspace.$1 label=$label
