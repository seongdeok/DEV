#!/bin/bash

# ghostty 앱이 실행 중인지 확인
osascript <<EOF
    tell application "System Events"
        set window_list to every window of process "Ghostty"
        set window_info to {}
        repeat with win in window_list
            set win_info to {}
            set win_title to name of win
            set win_position to position of win
            set win_size to size of win
            set win_index to index of win
            copy {title:win_title, position:win_position, size:win_size, index:win_index} to end of window_info
        end repeat
        return window_info
    end tell
EOF
