
add_text_if_none() {
  local file="$1"
  local text="$2"
  if [ ! -f "$file" ]; then
    echo "$text" > "file"
    return
  fi
  if ! grep -Fxq "$text" "$file"; then
    echo "$text" >> "$file"
}



sudo pacman -S adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts
sudo pacman -S cscope universal-ctags curl ttf-font-awesome ghostty bluez bluez-utils 
yay -S --needed --noconfirm ttf-hack-nerd kime-bin ttf-nerd-fonts-symbols-mono tmux neovim ripgrep waynergy google-chrome ttf-nanum ripgrep ghostty visual-studio-code-bin
yay -S --needed --noconfirm zoxide yazi fd bat eza ripgrep ueberzugpp btop duf dust procs tldr nodejs npm zip unzip nwg-displays
yay -S --needed --noconfirm wezterm-git lua-language-server 
mkdir -p ~/.config/tmux
mkdir -p ~/.config/.tmux
# nvim
rm -rf ~/.config/nvim
ln -s $PWD/nvim ~/.config/nvim
echo 'alias vi=nvim' >>~/.zshrc
# tmux
ln -s $PWD/.tmux.conf ~/.config/tmux/tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#kime
#ln -s $PWD/kime ~/.config/kime

#wayne3rgy
ln -s $PWD/waynergy ~/.config/waynergy
#hyprland settings
#ln -s $PWD/hypr_user_config ~/.config/hypr/UserConfigs


#ghostty
rm -rf ~/.config/ghostty
ln -s $PWD/ghostty ~/.config/ghostty

ln -s $PWD/.wezterm.lua ~/.wezterm.lua

mkdir -p ~/.config/systemd/user
cp $PWD/waynergy.service ~/.config/systemd/user/
systemctl --user enable waynergy.service

$PWD/zsh_setup.sh

rm ~/.zshrc
ln -s $PWD/.zshrc ~/.zshrc

rm ~/.config/starship.toml
ln -s $PWD/starship/starship.toml ~/.config/starship.toml
#cp $PWD/code-flags.conf ~/.config/
#sudo cp sddm.conf /etc/sddm.conf

rm ~/.config/hypr/omarchy_hypr
ln -s $PWD/omarchy_hypr ~/.config/hypr/omarchy_hypr
add_text_if_none "~/.config/hypr/hyprland.conf" "source = ~/.config/hypr/omarchy_hypr/env.conf"
add_text_if_none "~/.config/hypr/hyprland.conf" "source = ~/.config/hypr/omarchy_hypr/execs.conf"
add_text_if_none "~/.config/hypr/hyprland.conf" "source = ~/.config/hypr/omarchy_hypr/keybinds.conf"
add_text_if_none "~/.config/hypr/hyprland.conf" "source = ~/.config/hypr/omarchy_hypr/general.conf"
add_text_if_none "~/.config/hypr/hyprland.conf" "source = ~/.config/hypr/omarchy_hypr/rules.conf"

