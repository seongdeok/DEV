#!/usr/bin/sh
install_native() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y cmake terminator git build-essential cscope universal-ctags vim curl zsh fonts-powerline
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp ./.vimrc ~/.vimrc
  vim +PluginInstall +qall
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}
install_on_brew() {
  brew update
  brew install cscope universal-ctags vim curl zsh zsh-syntax-highlighting zsh-autosuggestions
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp ./.vimrc ~/.vimrc
  vim +PluginInstall +qall
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

if [ "$1" = "brew" ]; then
  install_on_brew
else
  install_native
fi
