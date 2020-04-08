# DEV


ubuntu 설치하기

sudo apt update
sudo apt upgrade
sudo apt install terminator git build-essential cscope ctags vim curl

Vim 설정
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
~/.vimrc에 복사
:PluginInstall 로 설치


ohmyzsh설치
sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo apt-get install fonts-powerline

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
add plugin .zshrc zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fuzzyfinder 설치
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh <== .zshrc에 추가

FZF(in shell)
- ctrl - t
- alt-c change directory

vim fzf
refer https://github.com/junegunn/fzf/wiki/Examples-(vim)




