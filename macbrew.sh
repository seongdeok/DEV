/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew install git cscope universal-ctags vim curl zsh neovim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s .vimrc ~/.vimrc
vim +PluginInstall +qall
brew install --cask ghostty craft rectangle raycast appcleaner keka karabiner-elements maccy alt-tab macs-fan-control
brew install --cask visual-studio-code
brew install --cask font-meslo-for-powerlevel10k
brew install ripgrep bash
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask nikitabobko/tap/aerospace
brew install wezterm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
echo "source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

ln -s ghostty ~/.config/ghostty

# For VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# For VSCode Insiders
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

# For VSCodium
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false

# To enable global key-repeat
# this is helpful if you're using Vim in a PWA like code-server
defaults write -g ApplePressAndHoldEnabled -bool false


brew tap FelixKratz/formulae
brew install borders
ln -s ./borders ~/.config/borders
brew services start borders

brew install neofetch

brew install sketchybar
brew install font-hack-nerd-font jq
brew install font-sf-pro
brew install --cask sf-symbols
brew install --cask font-sketchybar-app-font

