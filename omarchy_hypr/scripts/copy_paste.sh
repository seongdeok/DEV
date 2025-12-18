#!/bin/zsh
# Walker clipboard manager with smart auto-paste

# Store the active window address and class before opening walker
active_address=$(hyprctl activewindow -j | jq -r '.address')
active_class=$(hyprctl activewindow -j | jq -r '.class')

LOG=`hyprctl clients -j`
echo $LOG > /tmp/log

# Check if it's a terminal and send appropriate paste shortcut to the original window
case "$active_class" in
    *kitty*|*alacritty*|*wezterm*|*foot*|*ghostty*|*term*)
        # Terminal: use Ctrl+Shift+V
        hyprctl dispatch sendshortcut CTRL+SHIFT, V, address:$active_address
        ;;
    *)
        # Other apps: use Ctrl+V
        hyprctl dispatch sendshortcut CTRL, V, address:$active_address
        ;;
esac
