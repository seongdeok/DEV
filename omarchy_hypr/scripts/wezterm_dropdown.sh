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
TAG="DROPTERM_FOCUS"


echo "Active DROPterm = $ACTIVE_DROPTERM" >> /tmp/dropterm
echo "exsiting DROPterm = $EXISTING_DROPTERM" >> /tmp/dropterm
echo "window id = $WINDOW_ID" >> /tmp/dropterm


move_to_workspace() {
    local TARGET_WS="$1"

    echo "🔍 TARGET_WS=$TARGET_WS" >&2

    local WS_INFO
    WS_INFO=$(hyprctl -j workspaces | jq ".[] | select(.name==\"$TARGET_WS\" or .id==$TARGET_WS)")
    echo "🧩 WS_INFO(from workspaces): $WS_INFO" >&2

    if [ -z "$WS_INFO" ]; then
        WS_INFO=$(hyprctl -j monitors | jq ".[] | select(.activeWorkspace.name==\"$TARGET_WS\" or .activeWorkspace.id==$TARGET_WS) | .activeWorkspace")
        echo "🧩 WS_INFO(from monitors): $WS_INFO" >&2
    fi

    if [ -z "$WS_INFO" ]; then
        echo "❌ workspace 정보를 찾을 수 없습니다: $TARGET_WS" >&2
        return 1
    fi

    local MONITOR_NAME
    MONITOR_NAME=$(echo "$WS_INFO" | jq -r '.monitor')
    echo "🖥️ MONITOR_NAME=$MONITOR_NAME" >&2

    local MONITOR_INFO
    MONITOR_INFO=$(hyprctl -j monitors | jq ".[] | select(.name==\"$MONITOR_NAME\")")
    echo "📺 MONITOR_INFO=$MONITOR_INFO" >&2

    if [ -z "$MONITOR_INFO" ]; then
        echo "❌ 모니터 정보를 찾을 수 없습니다: $MONITOR_NAME" >&2
        return 1
    fi

    local RES_X RES_Y POS_X POS_Y
    RES_X=$(echo "$MONITOR_INFO" | jq '.width')
    RES_Y=$(echo "$MONITOR_INFO" | jq '.height')
    POS_X=$(echo "$MONITOR_INFO" | jq '.x')
    POS_Y=$(echo "$MONITOR_INFO" | jq '.y')

    local TARGET_W TARGET_H TARGET_X TARGET_Y
    TARGET_W=$(( RES_X * 70 / 100 ))
    TARGET_H=$(( RES_Y * 50 / 100 ))
    TARGET_X=$(( POS_X + (RES_X - TARGET_W) / 2 ))
    TARGET_Y=$(( POS_Y + (RES_Y - TARGET_H) / 2 ))
    
    echo "w,h,x,y = $TARGET_W $TARGET_H $TARGET_X $TARGET_Y" >> /tmp/dropterm
    echo $MONITOR_INFO  >> /tmp/dropterm
    echo $WS_INFO >> /tmp/dropterm
    echo "res x,y = $RES_X,$RES_Y,  pos x,y=$POS_X , $POS_Y" >> /tmp/dropterm
    hyprctl dispatch resizeactive exact $TARGET_W $TARGET_H
    hyprctl dispatch moveactive exact $TARGET_X $TARGET_Y
}


if [[ -n "$ACTIVE_DROPTERM" ]]; then
#현재 포커스가 dropterm이면 숨김
  hyprctl dispatch togglespecialworkspace dropterm
  #hyprctl dispatch movetoworkspace DROPDROP
  sleep 0.2
  WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.tags[]? == \"$TAG\") | .address" | head -n 1)
  if [ -n "$WIN_ID" ]; then
    hyprctl dispatch focuswindow address:$WIN_ID
    hyprctl dispatch tagwindow $TAG
  else
    echo "태그 '$TAG'를 가진 창이 없습니다."
    hyprctl dispatch cyclenext visible hist 
  fi
  #hyprctl dispatch cyclenext visible hist 
elif [[ -n "$WINDOW_ID" ]]; then
#창은 있는데 포커스가 아니면 가져오기
  hyprctl dispatch tagwindow $TAG
  hyprctl dispatch focuswindow address:$WINDOW_ID
  move_to_workspace $CUR_WS
else
#창이 없으면 새로 실행하고 focus
  hyprctl dispatch tagwindow $TAG
  wezterm --config-file ${LUA_FILE} start --class $CLASS &
  sleep 0.5
  hyprctl dispatch focuswindow title:$TITLE
fi
