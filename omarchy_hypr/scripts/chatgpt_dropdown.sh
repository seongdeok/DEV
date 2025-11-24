#!/bin/bash

check_http() {
    local url=$1
    # -s: 조용히 실행, -o /dev/null: 출력 버림, -w "%{http_code}": HTTP 상태 코드만 출력
    local status_code=$(curl --max-time 0.5 -s -o /dev/null -w "%{http_code}" "$url")

    if [[ "$status_code" -ge 200 && "$status_code" -lt 400 ]]; then
        #echo "✅ $url 접속 성공 (HTTP $status_code)"
        return 0
    else
        #echo "❌ $url 접속 실패 (HTTP $status_code)"
        return 1
    fi
}

if check_http "https://app.eaip.lge.com/lgenie"; then
  CLASS="chrome-app.eaip.lge.com__lgenie_-Default"
  TITLE="LGenie.AI"
  URL="https://app.eaip.lge.com/lgenie/"
else
  CLASS="chrome-chatgpt.com__-Default"
  TITLE="ChatGPT"
  URL="https://chatgpt.com"
fi
TAG="DROP_CHATGPT_FOCUS"

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
  hyprctl dispatch togglespecialworkspace chatgpt 
  sleep 0.2
  WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.tags[]? == \"$TAG\") | .address" | head -n 1)
  if [ -n "$WIN_ID" ]; then
    hyprctl dispatch focuswindow address:$WIN_ID
    hyprctl dispatch tagwindow $TAG
  else
    echo "태그 '$TAG'를 가진 창이 없습니다."
    hyprctl dispatch cyclenext visible hist 
  fi
elif [[ -n "$WINDOW_ID" ]]; then
#창은 있는데 포커스가 아니면 가져오기
  hyprctl dispatch tagwindow $TAG
  hyprctl dispatch focuswindow address:$WINDOW_ID
  move_to_workspace $CUR_WS
else
#창이 없으면 새로 실행하고 focus
  #google-chrome-stable "https://app.eaip.lge.com/lgenie/public" --class $CLASS 
  hyprctl dispatch tagwindow $TAG
  if check_http "https://app.eaip.lge.com/lgenie"; then
    omarchy-launch-webapp "https://app.eaip.lge.com/lgenie/" 
  else
    omarchy-launch-webapp "https://chatgpt.com" 
  fi
fi
