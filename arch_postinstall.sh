sudo pacman -S adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts
yay -S ttf-nanum
sudo pacman -S cscope universal-ctags curl ttf-font-awesome ghostty
yay -S kime ttf-nerd-fonts-symbols-mono tmux neovim ripgrep waynergy google-chrome
mkdir -p ~/.config/tmux
mkdir -p ~/.config/.tmux
# nvim
ln -s $PWD/nvim ~/.config/nvim
echo 'alias vi=nvim' >> ~/.zshrc
# tmux
ln -s $PWD/.tmux.conf ~/.config/tmux/tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#kime
ln -s $PWD/kime ~/.config/kime

#wayne3rgy
ln -s $PWD/waynergy ~/.config/waynergy
#hyprland settings
ln -s $PWD/hypr_user_config ~/.config/hypr/UserConfigs

#ghostty
ln -s $PWD/ghostty ~/.config/ghostty

