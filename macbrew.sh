/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew install git cscope universal-ctags vim curl zsh neovim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s .vimrc ~/.vimrc
vim +PluginInstall +qall
brew install --cask ghostty
brew install —-cask craft rectangle raycast appcleaner
brew install --cask keka
brew install --cask karabiner-elements
brew install --cask maccy
brew install --cask alt-tab
brew install --cask macs-fan-control
brew install --cask visual-studio-code
brew install --cask font-meslo-for-powerlevel10k

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

