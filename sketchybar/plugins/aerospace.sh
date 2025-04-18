#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors


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


