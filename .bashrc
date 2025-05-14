# vi 모드 사용
set -o vi

# 방향키 바인딩 (Ctrl 키와 함께)
bind '"\C-k": "\e[A"'   # Ctrl-k → 위
bind '"\C-j": "\e[B"'   # Ctrl-j → 아래
bind '"\C-l": "\e[C"'   # Ctrl-l → 오른쪽
bind '"\C-h": "\e[D"'   # Ctrl-h → 왼쪽
