#!/bin/bash

selected=$(aerospace list-windows --all | fzf --prompt="Choose window > ")

# 선택한 줄에서 윈도우 ID (첫 번째 필드) 추출
window_id=$(echo "$selected" | awk '{print $1}')

# 포커스 이동
if [ -n "$window_id" ]; then
  aerospace focus --window-id "$window_id"
fi
