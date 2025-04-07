#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    icon="$sid"
    label=""
    number=0
    sketchybar --add item "workspace.$sid.$number" left \
        --subscribe "workspace.$sid.$number" aerospace_workspace_change \
        --set "workspace.$sid.$number" \
        padding_left=2 \
        padding_right=2 \
        background.corner_radius=5 \
        background.height=30 \
        background.drawing=on \
        background.border_width=6 \
        label.string="$sid" \
        label.font="SF Pro:Semibold:15.0" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
    while IFS='|' read -r app title; do
      app_icon=$(~/dotfiles/sketchybar/plugins/icon_map_fn.sh "$app")
      label+="$app_icon abcdef "
      # label+="$title "
      number=$((number+1))
      echo "$number"
      sketchybar --add item "workspace.$sid.$number" left \
          --set "workspace.$sid.$number" \
          label="$app_icon" \
          label.font="sketchybar-app-font:Regular:16.0" \
          click_script="aerospace workspace $sid" \
          script="$PLUGIN_DIR/aerospace.sh $sid"
    done < <(aerospace list-windows --workspace "$sid" --format "%{app-name}|%{window-title}")
    if [ -z "$label" ]; then
      label="Empty"
    fi
    sketchybar --add bracket workspace.$sid "/workspace\.$sid\..*/"  \
           --subscribe "workspace.$sid" aerospace_workspace_change \
           --set  workspace.$sid background.color=0xffbc92e8 \
              background.corner_radius=4  \
              background.height=30 \
              background.drawing=on \
              script="$PLUGIN_DIR/aerospace.sh $sid"
done
