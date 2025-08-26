info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

info "Tapping FelixKratz/formulae..."
brew tap FelixKratz/formulae
if ! command -v brew &>/dev/null; then
  info "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
info "Updating Homebrew..."
brew update

info "Installing Homebrew formulae..."
for pkg in git cscope universal-ctags vim curl zsh neovim ripgrep bash wezterm neofetch borders sketchybar font-hack-nerd-font jq font-sf-pro; do
  if ! brew list --formula | grep -q "^$pkg$"; then
    info "Installing $pkg..."
    brew install "$pkg"
  else
    info "$pkg already installed. Skipping."
  fi
done

info "Installing Homebrew casks..."
for cask in ghostty craft rectangle raycast appcleaner keka karabiner-elements maccy alt-tab macs-fan-control visual-studio-code font-meslo-for-powerlevel10k font-jetbrains-mono-nerd-font nikitabobko/tap/aerospace sf-symbols font-sketchybar-app-font; do
  if ! brew list --cask | grep -q "^$cask$"; then
    info "Installing cask $cask..."
    brew install --cask "$cask"
  else
    info "Cask $cask already installed. Skipping."
  fi
done

info "Checking VundleVim installation..."
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  info "Installing VundleVim..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
  info "VundleVim already installed. Skipping."
fi
info "Checking .vimrc symlink..."
if [ ! -L "$HOME/.vimrc" ]; then
  info "Creating .vimrc symlink..."
  ln -s .vimrc ~/.vimrc
else
  info ".vimrc symlink already exists. Skipping."
fi
info "Installing Vim plugins..."
vim +PluginInstall +qall

info "Checking Oh My Zsh installation..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  info "Oh My Zsh already installed. Skipping."
fi

info "Checking zsh-autosuggestions installation..."
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
else
  info "zsh-autosuggestions already installed. Skipping."
fi
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc; then
  info "Adding zsh-autosuggestions to .zshrc..."
  echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
else
  info "zsh-autosuggestions already in .zshrc. Skipping."
fi

info "Checking zsh-syntax-highlighting installation..."
if [ ! -d "$HOME/.zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
else
  info "zsh-syntax-highlighting already installed. Skipping."
fi
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc; then
  info "Adding zsh-syntax-highlighting to .zshrc..."
  echo "source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
else
  info "zsh-syntax-highlighting already in .zshrc. Skipping."
fi

info "Checking fzf installation..."
if [ ! -d "$HOME/.fzf" ]; then
  info "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
else
  info "fzf already installed. Skipping."
fi

info "Checking powerlevel10k installation..."
if [ ! -d "$HOME/powerlevel10k" ]; then
  info "Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
else
  info "powerlevel10k already installed. Skipping."
fi
if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc; then
  info "Adding powerlevel10k to .zshrc..."
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
else
  info "powerlevel10k already in .zshrc. Skipping."
fi

info "Checking ghostty symlink..."
if [ ! -L "$HOME/.config/ghostty" ]; then
  info "Creating ghostty symlink..."
  ln -s ghostty ~/.config/ghostty
else
  info "ghostty symlink already exists. Skipping."
fi

info "Configuring VSCode key repeat settings..."
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
defaults write -g ApplePressAndHoldEnabled -bool false

info "Checking borders symlink..."
if [ ! -L "$HOME/.config/borders" ]; then
  info "Creating borders symlink..."
  ln -s ./borders ~/.config/borders
else
  info "borders symlink already exists. Skipping."
fi
info "Starting borders service..."
brew services start borders

