#!/usr/bin/env bash

get_workspace_monitor_info() {
    local TARGET_WS="$1"

    # 1️⃣ workspaces에서 먼저 찾기
    local WS_INFO
    WS_INFO=$(hyprctl -j workspaces | jq ".[] | select(.name==\"$TARGET_WS\" or .id==$TARGET_WS)")

    # 2️⃣ 없으면 monitors에서 현재 워크스페이스 확인
    if [ -z "$WS_INFO" ]; then
        WS_INFO=$(hyprctl -j monitors | jq ".[] | select(.activeWorkspace.name==\"$TARGET_WS\" or .activeWorkspace.id==$TARGET_WS) | .activeWorkspace")
    fi

    if [ -z "$WS_INFO" ]; then
        echo "❌ workspace 정보를 찾을 수 없습니다: $TARGET_WS" >&2
        return 1
    fi

    # 모니터 이름 추출
    local MONITOR_NAME
    MONITOR_NAME=$(echo "$WS_INFO" | jq -r '.monitor')

    # 모니터 정보 가져오기
    local MONITOR_INFO
    MONITOR_INFO=$(hyprctl -j monitors | jq ".[] | select(.name==\"$MONITOR_NAME\")")

    if [ -z "$MONITOR_INFO" ]; then
        echo "❌ 모니터 정보를 찾을 수 없습니다: $MONITOR_NAME" >&2
        return 1
    fi

    # 모니터 해상도 및 위치 추출
    local RES_X RES_Y POS_X POS_Y
    RES_X=$(echo "$MONITOR_INFO" | jq '.width')
    RES_Y=$(echo "$MONITOR_INFO" | jq '.height')
    POS_X=$(echo "$MONITOR_INFO" | jq '.x')
    POS_Y=$(echo "$MONITOR_INFO" | jq '.y')

    # JSON 형태로 출력 (리턴 역할)
    jq -n \
        --arg monitor "$MONITOR_NAME" \
        --argjson width "$RES_X" \
        --argjson height "$RES_Y" \
        --argjson x "$POS_X" \
        --argjson y "$POS_Y" \
        '{monitor: $monitor, width: $width, height: $height, x: $x, y: $y}'
}

# ✅ 사용 예시
info=$(get_workspace_monitor_info $1) || exit 1
echo "결과 JSON: $info"
