#!/bin/bash

CLASS="dropdown"
TITLE="dropterm"
LUA_FILE="$HOME/.config/hypr/omarchy_hypr/scripts/.wezterm_dropdown.lua"
#현재 활성 창이 dropterm인지 확인
ACTIVE_DROPTERM=$(hyprctl activewindow -j | jq -r --arg TITLE "$TITLE" 'select(.title == $TITLE) | .address')
#dropterm 창 전체 중 하나 가져오기
EXISTING_DROPTERM=$(hyprctl clients -j | jq -r --arg CLASS "$CLASS" '.[] | select(.initialClass == $CLASS) | .address')
WINDOW_ID="$EXISTING_DROPTERM"
CUR_WS=$(hyprctl activeworkspace -j | jq -r .id)

if [[ -n "$ACTIVE_DROPTERM" ]]; then
#현재 포커스가 dropterm이면 숨김
  hyprctl dispatch togglespecialworkspace dropterm
  sleep 0.4
  hyprctl dispatch cyclenext visible hist 
elif [[ -n "$WINDOW_ID" ]]; then
#창은 있는데 포커스가 아니면 가져오기
  hyprctl dispatch focuswindow address:$WINDOW_ID
else
#창이 없으면 새로 실행하고 focus
  wezterm --config-file ${LUA_FILE} start --class $CLASS &
  sleep 0.8
  hyprctl dispatch focuswindow title:$TITLE
fi
