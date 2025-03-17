#!/usr/bin/env osascript

--------------------------------------------------------------------------------
-- 설정 (property)
--------------------------------------------------------------------------------
property debugMode : true           -- true면 로그를 콘솔에 찍음
property appBundleName : "Ghostty"  -- open -a 실행 시 쓰는 이름
property binName : "ghostty"        -- pgrep로 확인할 실제 프로세스 이름(소문자)

--------------------------------------------------------------------------------
-- 메인 실행부
--------------------------------------------------------------------------------
on run
    debugLog("Script started.")

    -- 1) pgrep 체크
    set isRunning to isProcessRunning(binName)

    if isRunning then
        debugLog("Process \"" & binName & "\" is running. Bringing app to front and sending Cmd+N.")
        -- 이미 실행 중이면 전면화
        do shell script "open -a " & quoted form of appBundleName

        -- ⌘+N (Ghostty가 이 단축키로 새 창을 열도록 구현되어 있어야 함)
        tell application "System Events"
            keystroke "n" using {command down}
        end tell

        debugLog("⌘+N sent to \"" & binName & "\".")

    else
        debugLog("Process \"" & binName & "\" NOT running. Launching " & appBundleName & ".")
        -- 실행 중 아니면 앱 실행
        do shell script "open -a " & quoted form of appBundleName
    end if

    debugLog("Script finished.")
end run

--------------------------------------------------------------------------------
-- 콘솔 로그 찍기 (echo)
--------------------------------------------------------------------------------
on debugLog(msg)
    if debugMode then
        -- 작은 따옴표 안에 msg를 넣기 위해서 escaped quotes 처리
        -- 또는 큰따옴표 + quoted form
        do shell script "echo " & quoted form of ("[DEBUG] " & msg) & " >> " & quoted form of "/tmp/log.txt"
    end if
end debugLog

--------------------------------------------------------------------------------
-- pgrep를 통한 프로세스 존재 확인 (디버그 메시지 포함)
--------------------------------------------------------------------------------
on isProcessRunning(pName)
    if application pName is running then
        return true
    else
        return false
    end if
end isProcessRunning

