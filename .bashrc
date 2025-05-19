# vi 모드 사용
set -o vi

# 방향키 바인딩 (Ctrl 키와 함께)
bind '"\C-k": "\e[A"'   # Ctrl-k → 위
bind '"\C-j": "\e[B"'   # Ctrl-j → 아래
bind '"\C-l": "\e[C"'   # Ctrl-l → 오른쪽
bind '"\C-h": "\e[D"'   # Ctrl-h → 왼쪽
# ---------------------------------------------
# 🧠 Bash History 안전 저장 설정
# ---------------------------------------------
export HISTFILESIZE=100000
export HISTSIZE=100000
shopt -s histappend
export PROMPT_COMMAND='history -a; history -n'
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="&:ls:bg:fg:history:clear"

# 터미널별로 별도 history 파일 저장 (tmux 세션 충돌 방지)
if [[ -n "$TMUX" ]]; then
  export HISTFILE=~/.bash_history_tmux_$(tmux display-message -p "#S_#I_#P")
else
  export HISTFILE=~/.bash_history
fi

# ---------------------------------------------
# 🔍 fzf 설정 (brew 설치 기준)
# ---------------------------------------------
if [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.bash" ]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
fi
if [ -f "$(brew --prefix)/opt/fzf/shell/completion.bash" ]; then
  source "$(brew --prefix)/opt/fzf/shell/completion.bash"
fi

export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# ---------------------------------------------
# 📁 zoxide 설정
# ---------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# zoxide + fzf 연동
zi() {
  cd "$(zoxide query -l | fzf)" || echo "취소됨"
}

# ---------------------------------------------
# 💄 starship prompt (선택)
# ---------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# ---------------------------------------------
# 💡 편의 alias 모음
# ---------------------------------------------
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

alias gs='git status'
alias gc='git commit'
alias gl='git log --oneline --graph --decorate'

alias tm='tmux attach || tmux new -s main'
