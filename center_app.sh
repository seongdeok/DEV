#!/bin/sh

osascript -e '
set appName to "Ghostty" -- 여기서 앱 이름 변경 가능

tell application "Finder"
    set screenBounds to bounds of window of desktop
    set screenWidth to item 3 of screenBounds
    set screenHeight to item 4 of screenBounds
end tell

tell application "System Events"
    tell process appName
        if (count of windows) > 0 then
            set win to window 1

            set newWidth to screenWidth / 2
            set newHeight to screenHeight
            set newX to (screenWidth - newWidth) / 2
            set newY to 0

            set position of win to {newX, newY}
            set size of win to {newWidth, newHeight}
        else
            display notification appName & "에는 열려 있는 창이 없습니다."
        end if
    end tell
end tell'

