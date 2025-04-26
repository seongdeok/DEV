#!/bin/bash

# 전체 모드 목록 가져오기
modes=($(aerospace list-modes))

# 현재 모드 가져오기
current_mode=$(aerospace list-modes --current)

# 다음 모드 찾기
next_mode=""
for ((i=0; i<${#modes[@]}; i++)); do
    if [[ "${modes[i]}" == "$current_mode" ]]; then
        next_index=$(( (i + 1) % ${#modes[@]} ))
        next_mode=${modes[next_index]}
        break
    fi
done

# 결과 출력
echo "현재 모드: $current_mode"
echo "다음 모드: $next_mode"
aerospace mode $next_mode
sketchybar --trigger aerospace_mode_change
