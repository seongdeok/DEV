brew install starship nvim zoxide curl bat ctags cscope fzf tmux yazi eza npm
echo "alias vi='nvim'" >> ~/.bashrc

echo 'eval "$(starship init bash)"' >> ~/.bashrc
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.config
ln -s ./nvim ~/.config/nvim

echo "alias ls='eza --color=always --group-directories-first --icons'" >> ~/.bashrc
echo "alias ll='eza -la --icons --octal-permissions --group-directories-first'" >> ~/.bashrc
echo "alias l='eza -bGF --header --git --color=always --group-directories-first --icons'" >> ~/.bashrc

ln -s $PWD/nvim ~/.config/nvim
ln -s $PWD/.tmux.conf ~/.tmux.conf

