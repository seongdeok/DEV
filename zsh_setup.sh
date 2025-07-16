sudo pacman -S zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

ZSHRC="$HOME/.zshrc"
LINE='eval "$(starship init zsh)"'

# 파일이 없으면 생성
[ -f "$ZSHRC" ] || touch "$ZSHRC"

# 중복 방지하고 추가
grep -qxF "$LINE" "$ZSHRC" || echo "$LINE" >> "$ZSHRC"

