sudo pacman -S adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts
sudo pacman -S cscope universal-ctags curl ttf-font-awesome ghostty bluez bluez-utils network-manager-applet
yay -S --needed --noconfirm ttf-hack-nerd kime-bin ttf-nerd-fonts-symbols-mono tmux neovim ripgrep waynergy google-chrome ttf-nanum icaclient ripgrep teams-for-linux-bin ghostty visual-studio-code-bin
yay -S --needed --noconfirm zoxide yazi fd bat eza ripgrep ueberzugpp btop duf dust procs tldr nodejs npm zip unzip nwg-displays
yay -S --needed --noconfirm  wezterm-git
#yay -S sddm blueman network-manager-applet
sudo pacman -S networkmanager nm-connection-editor bluez bluez-utils polkit-gnome
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
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
#ln -s $PWD/hypr_user_config ~/.config/hypr/UserConfigs

#ghostty
ln -s $PWD/ghostty ~/.config/ghostty

ln -s $PWD/.wezterm.lua ~/.wezterm.lua

mkdir -p ~/.config/systemd/user
cp $PWD/waynergy.service ~/.config/systemd/user/
systemctl --user enable waynergy.service
cp $PWD/code-flags.conf ~/.config/
