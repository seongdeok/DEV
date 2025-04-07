#!/bin/sh

for sid in $(aerospace list-workspaces --all); do
    label=" "
    for app in $(aerospace list-windows --workspace $sid --format %{app-name}); do
      label+=$app  
      echo "==>|$app|"
      icon=" $(~/dotfiles/sketchybar/plugins/icon_map_fn.sh "$app")"
      echo "icon $icon"
    done
    echo $label
done
echo "--------------------------"


aerospace list-windows --workspace 1 --format "%{app-name}|%{window-title}" | while IFS='|' read -r app title; do
    echo "App: $app, Title: $title"
done

while IFS='|' read -r app title; do
    echo "App: $app, Title: $title"
done <<$(aerospace list-windows --workspace 1 --format "%{app-name}|%{window-title}")
