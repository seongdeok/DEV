#!/bin/bash

CLASS="chrome-app.eaip.lge.com__lgenie_-Default"
TITLE="LGenie.AI"
#현재 활성 창이 dropterm인지 확인
ACTIVE_DROPTERM=$(hyprctl activewindow -j | jq -r --arg TITLE "$TITLE" 'select(.title == $TITLE) | .address')
#dropterm 창 전체 중 하나 가져오기
EXISTING_DROPTERM=$(hyprctl clients -j | jq -r --arg CLASS "$CLASS" '.[] | select(.initialClass == $CLASS) | .address')
WINDOW_ID="$EXISTING_DROPTERM"
CUR_WS=$(hyprctl activeworkspace -j | jq -r .id)

echo active dropterm =$ACTIVE_DROPTERM >> /tmp/msg
echo existing=$EXISTING_DROPTERM >> /tmp/msg
echo window_id=$WINDOW_ID >> /tmp/msg
echo ws=$CUR_WS >> /tmp/msg

if [[ -n "$ACTIVE_DROPTERM" ]]; then
#현재 포커스가 dropterm이면 숨김
  hyprctl dispatch togglespecialworkspace chatgpt 
  sleep 0.4
  hyprctl dispatch cyclenext visible hist 
elif [[ -n "$WINDOW_ID" ]]; then
#창은 있는데 포커스가 아니면 가져오기
  hyprctl dispatch focuswindow address:$WINDOW_ID
else
#창이 없으면 새로 실행하고 focus
  #google-chrome-stable "https://app.eaip.lge.com/lgenie/public" --class $CLASS 
  omarchy-launch-webapp "https://app.eaip.lge.com/lgenie/" 
fi
