-- 고유 프로필 경로 (태그 역할)
set profileDir to "/tmp/chromium_lge_exaone"
set appURL to "https://lge.exaone.ai"
set appName to "Chromium"

-- 실행 여부 확인 (고유 프로필 경로로 판별)
set isRunning to false
try
    set procList to do shell script "ps aux | grep '" & profileDir & "' | grep -v grep"
    if procList is not "" then set isRunning to true
end try

if isRunning then
    -- 이미 실행 중이면 Aerospace로 workspace 이동
    do shell script "/usr/local/bin/aerospace move-node-to-workspace 3"
else
    -- 새로 실행
    do shell script "open -a '" & appName & "' --args --app=" & appURL & " --user-data-dir=" & profileDir
    delay 1
    -- 화면 중앙 배치
    tell application "System Events"
        tell application process appName
            set win to window 1
            set {screenWidth, screenHeight} to {1440, 900} -- 모니터 해상도
            set winWidth to 1000
            set winHeight to 700
            set posX to (screenWidth - winWidth) / 2
            set posY to (screenHeight - winHeight) / 2
            set position of win to {posX, posY}
            set size of win to {winWidth, winHeight}
        end tell
    end tell
end if
