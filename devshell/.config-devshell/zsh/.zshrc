# .config-devshell/zsh/.zshrc

# zsh plugins
[ -f "$ZSH_AUTOSUGGESTIONS_PATH" ] && source "$ZSH_AUTOSUGGESTIONS_PATH"
[ -f "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ] && source "$ZSH_SYNTAX_HIGHLIGHTING_PATH"


# Environment
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range :500 {}'

# Nix 설치 경로에서 로딩
if [ -f "$FZF_KEYBINDINGS_PATH" ]; then
  source $FZF_KEYBINDINGS_PATH
fi

if [ -f "$FZF_COMPLETION_PATH" ]; then
  source $FZF_COMPLETION_PATH
fi


export EDITOR=nvim
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"


# Prompt: show directory only
autoload -U colors && colors
setopt autocd
setopt correct
bindkey -e

# Aliases
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias grep='rg'
alias cat='bat'

eval "$(zoxide init zsh)"

# Starship prompt
eval "$(starship init zsh)"
# ───────────────────────────────────────────────
# Welcome message (neofetch)
if command -v neofetch &>/dev/null; then
  neofetch
fi
