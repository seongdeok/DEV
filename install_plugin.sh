#!/usr/bin/zsh
cd /tmp
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/
#source ./zsh-autosuggestions/zsh-autosuggestions.zsh
echo "Add zsh-autosuggestions to your .zshrc"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
