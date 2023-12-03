#!/bin/sh
install_native() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y cmake terminator git build-essential cscope universal-ctags vim curl zsh fonts-powerline
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp ./.vimrc ~/.vimrc
  vim +PluginInstall +qall
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}
install_on_brew() {
  brew update
  brew install cscope universal-ctags vim curl zsh
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  cp ./.vimrc ~/.vimrc
  vim +PluginInstall +qall
  echo "export SHELL=$(brew --prefix)/bin/zsh" >> ~/.bashrc
  echo "exec $(brew --prefix)/bin/zsh" >> ~/.bashrc

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

if [ "$1" = "brew" ]; then
  install_on_brew
else
  install_native
fi
