#!/bin/bash

while true; do
    # 1. 현재 볼륨 가져오기
    CUR_VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100 "%"}')

    # 2. 메뉴 구성 (항목 이름에 현재 볼륨과 단축키를 모두 포함)
    # 첫 글자를 k와 j로 해서 시각적으로 단축키임을 알림
    CHOICE=$(echo -e "k: [UP]   (Current: $CUR_VOL)\nj: [DOWN] (Current: $CUR_VOL)" | walker --dmenu -n -k )

    # 3. 선택에 따른 동작
    case "$CHOICE" in
        "k:"*)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            ;;
        "j:"*)
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            ;;
        "") 
            # ESC를 누르면 빈 값이 반환됨
            exit 0
            ;;
        *)
            # q 등 다른 키 입력 시 종료
            if [[ "$CHOICE" == "q" ]]; then exit 0; fi
            ;;
    esac
done
