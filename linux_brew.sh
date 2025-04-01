brew install starship nvim zoxide curl bat ctags cscope fzf tmux yazi
echo "alias vi='nvim'" >> ~/.bashrc
git clone https://github.com/ryanoasis/nerd-fonts.git --depth=1
cd nerd-fonts
./install.sh
cd ~
eval "$(starship init bash)" >> ~/.bashrc
