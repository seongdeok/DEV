sudo pacman -S iw wpa_supplicant networkmanager vim nvim zsh
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo systemctl enable wpa_supplicant.service
sudo systemctl start wpa_supplicant.service
sudo pacman -S bluez bluez-utils gnome-bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
sudo pacman -S adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts
yay -S ttf-nanum
sudo pacman -S ibus ibus-hangul cscope universal-ctags curl zsh wofi waybar ttf-font-awesome
sh -c "$(curl -fsSL [https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh))"
