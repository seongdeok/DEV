brew tap FelixKratz/formulae
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update

# Homebrew formulae
for pkg in git cscope universal-ctags vim curl zsh neovim ripgrep bash wezterm neofetch borders sketchybar font-hack-nerd-font jq font-sf-pro; do
  if ! brew list --formula | grep -q "^$pkg$"; then
    brew install "$pkg"
  fi
done

# Homebrew casks
for cask in ghostty craft rectangle raycast appcleaner keka karabiner-elements maccy alt-tab macs-fan-control visual-studio-code font-meslo-for-powerlevel10k font-jetbrains-mono-nerd-font nikitabobko/tap/aerospace sf-symbols font-sketchybar-app-font; do
  if ! brew list --cask | grep -q "^$cask$"; then
    brew install --cask "$cask"
  fi
done

# VundleVim
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
# .vimrc symlink
if [ ! -L "$HOME/.vimrc" ]; then
  ln -s .vimrc ~/.vimrc
fi
vim +PluginInstall +qall

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# zsh-autosuggestions
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
  echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
fi

# zsh-syntax-highlighting
if [ ! -d "$HOME/.zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
fi
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc; then
  echo "source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
fi

# fzf
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi
if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc; then
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

# ghostty symlink
if [ ! -L "$HOME/.config/ghostty" ]; then
  ln -s ghostty ~/.config/ghostty
fi

# VSCode settings
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
defaults write -g ApplePressAndHoldEnabled -bool false

brew tap FelixKratz/formulae

# borders symlink
if [ ! -L "$HOME/.config/borders" ]; then
  ln -s ./borders ~/.config/borders
fi
brew services start borders

