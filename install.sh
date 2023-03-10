sudo apt update
sudo apt upgrade -y
sudo apt install -y cmake terminator git build-essential cscope universal-ctags vim curl zsh fonts-powerline
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp ./.vimrc ~/.vimrc
vim +PluginInstall +qall
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cd /tmp
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions
source ./zsh-autosuggestions/zsh-autosuggestions.zsh

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

