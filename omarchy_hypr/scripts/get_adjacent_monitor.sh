#!/usr/bin/env bash
set -euo pipefail
 
STRICT=false
DEBUG=false
MODE="both"   # both | left | right
 
for a in "${@:-}"; do
  case "$a" in
    --strict-overlap) STRICT=true ;;
    --debug) DEBUG=true ;;
    --left) MODE="left" ;;
    --right) MODE="right" ;;
  esac
done
# ---- 활성 모니터 얻기 (다중 폴백) ----
get_active() {
  local n
  n="$(hyprctl monitors -j 2>/dev/null | jq -r '.[]| select(.focused==true) | .name' | head -n1 || true)"
  [[ -n "$n" && "$n" != "null" ]] && { echo "$n"; return; }
 
  local m
  m="$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.monitor // .monitorID // empty' || true)"
  if [[ -n "$m" && "$m" != "null" ]]; then
    n="$(hyprctl monitors -j 2>/dev/null | jq -r --arg m "$m" '.[] | select(.name==$m or ((.id|tostring)==$m)) | .name' | head -n1)"
    [[ -n "$n" && "$n" != "null" ]] && { echo "$n"; return; }
  fi
 
  # cursorpos 폴백
  local cx cy
  read -r cx cy < <(hyprctl cursorpos 2>/dev/null || echo "0 0")
  n="$(hyprctl monitors -j 2>/dev/null | jq -r --argjson cx "${cx:-0}" --argjson cy "${cy:-0}" '
      .[] | select(($cx >= .x) and ($cx < (.x + .width)) and ($cy >= .y) and ($cy < (.y + .height))) | .name
    ' | head -n1)"
  [[ -n "$n" && "$n" != "null" ]] && { echo "$n"; return; }
}
 
ACTIVE="$(get_active || true)"
MONJSON="$(hyprctl monitors -j)"
 
if [[ "$DEBUG" == true ]]; then
  echo "[DEBUG] ACTIVE=${ACTIVE:-<none>}" >&2
  echo "[DEBUG] Monitors:" >&2
  echo "$MONJSON" | jq -r '.[] | "\(.name) id=\(.id) geom=\(.x),\(.y) \(.width)x\(.height) focused=\(.focused // false)"' >&2
fi
 
if [[ -z "${ACTIVE:-}" ]]; then
  [[ "$MODE" != "right" ]] && echo "LEFT="
  [[ "$MODE" != "left"  ]] && echo "RIGHT="
  exit 0
fi
 
# jq 로 좌/우 계산. 쉘 분기 없이 각각 한 번씩 실행해 값을 보장 출력.
calc_left() {
  jq -r --arg name "$ACTIVE" --argjson strict "$STRICT" '
    def overlaps_vert($a; $b):
      ( ($a.y) < ($b.y + $b.height) ) and ( ($b.y) < ($a.y + $a.height) );
 
    . as $all
    | ($all[] | select(.name==$name)) as $A
    | [ $all[]
        | select(.name != $A.name)
        | . as $M
        | . + { endX: (.x + .width) }
        | select(
            if $strict then
              (.endX <= $A.x) and overlaps_vert($M; $A)
            else
              (.endX <= $A.x + ($A.width/2))
            end
          )
      ]
    | sort_by(.endX) | last // empty | .name // ""
  ' <<< "$MONJSON"
}
 
calc_right() {
  jq -r --arg name "$ACTIVE" --argjson strict "$STRICT" '
    def overlaps_vert($a; $b):
      ( ($a.y) < ($b.y + $b.height) ) and ( ($b.y) < ($a.y + $a.height) );
 
    . as $all
    | ($all[] | select(.name==$name)) as $A
    | [ $all[]
        | select(.name != $A.name)
        | . as $M
        | select(
            if $strict then
              (.x >= ($A.x + $A.width)) and overlaps_vert($M; $A)
            else
              (.x >= $A.x + ($A.width/2))
            end
          )
      ]
    | sort_by(.x) | first // empty | .name // ""
  ' <<< "$MONJSON"
}
 
LEFT="$(calc_left)"
RIGHT="$(calc_right)"
 
[[ "$DEBUG" == true ]] && echo "[DEBUG] LEFT=$LEFT RIGHT=$RIGHT" >&2
 
case "$MODE" in
  left)  echo "$LEFT";;
  right) echo "$RIGHT";;
  both)
    echo "LEFT=${LEFT}"
    echo "RIGHT=${RIGHT}"
    ;;
esac
``
 
