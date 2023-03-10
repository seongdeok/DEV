
sudo apt update
sudo apt upgrade -y
sudo apt install -y cmake terminator git build-essential cscope universal-ctags vim curl zsh fonts-powerline
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp ./.vimrc ~/.vimrc
vim +PluginInstall +qall
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


