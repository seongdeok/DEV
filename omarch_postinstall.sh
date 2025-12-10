
add_text_if_none() {
  local file="$1"
  local text="$2"
  if [ ! -f "$file" ]; then
    echo "$text" > "file"
    return
  fi
  if ! grep -Fxq "$text" "$file"; then
    echo "$text" >> "$file"
  fi
}



sudo pacman -S --needed --noconfirm adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts
sudo pacman -S --needed --noconfirm cscope universal-ctags curl ttf-font-awesome ghostty bluez bluez-utils 
yay -S --needed --noconfirm ttf-hack-nerd kime-bin ttf-nerd-fonts-symbols-mono tmux neovim ripgrep waynergy google-chrome ttf-nanum ripgrep ghostty visual-studio-code-bin
yay -S --needed --noconfirm zoxide yazi fd bat eza ripgrep ueberzugpp btop duf dust procs tldr nodejs npm zip unzip nwg-displays
yay -S --needed --noconfirm wezterm-git lua-language-server 
mkdir -p $HOME/.config/tmux
mkdir -p $HOME/.config/.tmux
# nvim
rm -rf $HOME/.config/nvim
ln -s $PWD/nvim $HOME/.config/nvim
echo 'alias vi=nvim' >>$HOME/.zshrc
# tmux
ln -s $PWD/.tmux.conf $HOME/.config/tmux/tmux.conf
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

#kime
#ln -s $PWD/kime $HOME/.config/kime

#wayne3rgy
rm -rf $HOME/.config/waynergy
ln -s $PWD/waynergy $HOME/.config/waynergy
#hyprland settings
#ln -s $PWD/hypr_user_config $HOME/.config/hypr/UserConfigs


#ghostty
rm -rf $HOME/.config/ghostty
ln -s $PWD/ghostty $HOME/.config/ghostty

rm $HOME/.wezterm.lua
ln -s $PWD/.wezterm.lua $HOME/.wezterm.lua

mkdir -p $HOME/.config/systemd/user
cp $PWD/waynergy.service $HOME/.config/systemd/user/
systemctl --user enable waynergy.service

$PWD/zsh_setup.sh

rm $HOME/.zshrc
ln -s $PWD/.zshrc $HOME/.zshrc

rm $HOME/.config/starship.toml
ln -s $PWD/starship/starship.toml $HOME/.config/starship.toml
#cp $PWD/code-flags.conf $HOME/.config/
#sudo cp sddm.conf /etc/sddm.conf

rm -rf $HOME/.config/walker
ln -s $PWD/walker $HOME/.config/walker

rm $HOME/.config/hypr/omarchy_hypr
ln -s $PWD/omarchy_hypr $HOME/.config/hypr/omarchy_hypr
add_text_if_none "$HOME/.config/hypr/hyprland.conf" "source = $HOME/.config/hypr/omarchy_hypr/env.conf"
add_text_if_none "$HOME/.config/hypr/hyprland.conf" "source = $HOME/.config/hypr/omarchy_hypr/execs.conf"
add_text_if_none "$HOME/.config/hypr/hyprland.conf" "source = $HOME/.config/hypr/omarchy_hypr/keybinds.conf"
add_text_if_none "$HOME/.config/hypr/hyprland.conf" "source = $HOME/.config/hypr/omarchy_hypr/general.conf"
add_text_if_none "$HOME/.config/hypr/hyprland.conf" "source = $HOME/.config/hypr/omarchy_hypr/rules.conf"

rm -rf $HOME/.config/waybar
ln -s $PWD/waybar $HOME/.config/waybar

