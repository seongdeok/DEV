#!/bin/bash

# 사용법: workspace_cycle.sh next | prev
direction="$1"

if [ -z "$direction" ]; then
  echo "Usage: $0 next|prev"
  exit 1
fi

# 현재 포커스된 워크스페이스와 모니터 ID 가져오기
current_info=$(aerospace list-workspaces --focused)
current_ws=$(echo "$current_info" | awk '{print $1}')
current_monitor=$(echo "$current_info" | awk '{print $2}')

# 모든 워크스페이스 목록 가져오기 (번호, 모니터ID)
monitor_map=$(aerospace list-workspaces --all | awk '{print $1, $2}' | sort -k2,2 -k1,1n)

# 현재 모니터의 워크스페이스 목록
current_monitor_ws=$(echo "$monitor_map" | awk -v mon="$current_monitor" '$2 == mon {print $1}')

if [ "$direction" = "next" ]; then
  # 다음 워크스페이스 찾기
  target_ws=$(echo "$current_monitor_ws" | awk -v cur="$current_ws" '
    BEGIN {found=0}
    {
      if(found==1) {print $1; exit}
      if($1==cur) {found=1}
    }
  ')

  # 현재 모니터에서 마지막이면 다음 모니터 첫 워크스페이스
  if [ -z "$target_ws" ]; then
    monitors=$(echo "$monitor_map" | awk '{print $2}' | uniq)
    next_monitor=$(echo "$monitors" | awk -v cur="$current_monitor" '
      BEGIN {found=0}
      {
        if(found==1) {print $1; exit}
        if($1==cur) {found=1}
      }
    ')
    if [ -z "$next_monitor" ]; then
      next_monitor=$(echo "$monitors" | head -n1)
    fi
    target_ws=$(echo "$monitor_map" | awk -v mon="$next_monitor" '$2 == mon {print $1; exit}')
  fi

elif [ "$direction" = "prev" ]; then
  # 이전 워크스페이스 찾기
  target_ws=$(echo "$current_monitor_ws" | awk -v cur="$current_ws" '
    {
      if($1==cur) {print prev; exit}
      prev=$1
    }
  ')

  # 현재 모니터에서 첫 번째면 이전 모니터 마지막 워크스페이스
  if [ -z "$target_ws" ]; then
    monitors=$(echo "$monitor_map" | awk '{print $2}' | uniq)
    prev_monitor=$(echo "$monitors" | awk -v cur="$current_monitor" '
      {
        if($1==cur) {print last; exit}
        last=$1
      }
    ')
    if [ -z "$prev_monitor" ]; then
      prev_monitor=$(echo "$monitors" | tail -n1)
    fi
    target_ws=$(echo "$monitor_map" | awk -v mon="$prev_monitor" '$2 == mon {last=$1} END {print last}')
  fi
else
  echo "Invalid direction: $direction"
  exit 1
fi

# 이동
aerospace workspace "$target_ws"
