#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item workspace.$sid left \
        --subscribe workspace.$sid aerospace_workspace_change \
        --set workspace.$sid \
        padding_left=2 \
        padding_right=2 \
        background.color=0xff093aa8 \
        background.corner_radius=5 \
        background.height=30 \
        background.drawing=off \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done
