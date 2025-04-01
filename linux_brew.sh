brew install starship nvim zoxide curl bat ctags cscope fzf tmux yazi eza
echo "alias vi='nvim'" >> ~/.bashrc
git clone https://github.com/ryanoasis/nerd-fonts.git --depth=1
cd nerd-fonts
./install.sh
cd ~
eval "$(starship init bash)" >> ~/.bashrc
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir ~/.config
ln -s ./nvim ~/.config/nvim

echo "alias ls='eza --color=always --group-directories-first --icons'" >> ~/.bashrc
echo "alias ll='eza -la --icons --octal-permissions --group-directories-first'" >> ~/.bashrc
echo "alias l='eza -bGF --header --git --color=always --group-directories-first --icons'" >> ~/.bashrc

