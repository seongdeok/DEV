#!/bin/bash

sketchybar --add event aerospace_workspace_change

# for m in $(aerospace list-monitors --format %{monitor-id}}'); do
#   for i in $(aerospace list-workspaces --monitor $m); do


for m in $(aerospace list-monitors --format %{monitor-id} ); do
  for sid in $(aerospace list-workspaces --monitor $m); do
      label=""
      while IFS='|' read -r app title; do
        app_icon=$(~/dotfiles/sketchybar/plugins/icon_map_fn.sh "$app")
        label+="$app_icon"
      done < <(aerospace list-windows --workspace "$sid" --format "%{app-name}|%{window-title}")
      if [ -z "$label" ]; then
        label=":close:"
      fi
      sketchybar --add item workspace.$sid left \
          --set workspace.$sid \
            display=$m \
            icon.padding_left=10 \
            icon.padding_right=10 \
            background.corner_radius=5 \
            background.height=30 \
            background.border_width=6 \
            background.color=0xff07c28a \
            icon.string="$sid." \
            icon.font="SF Pro:Semibold:15.0" \
            label=$label \
            label.font="sketchybar-app-font:Regular:16.0" \
            label.padding_right=10 \
            click_script="aerospace workspace $sid" \
            script="$PLUGIN_DIR/aerospace.sh $sid" \
          --subscribe workspace.$sid aerospace_workspace_change \
          --subscribe workspace.$sid space_windows_change
   
  done
done
