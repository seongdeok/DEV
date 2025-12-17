#!/bin/zsh
# Walker clipboard manager with smart auto-paste

# Store the active window address and class before opening walker
active_address=$(hyprctl activewindow -j | jq -r '.address')
active_class=$(hyprctl activewindow -j | jq -r '.class')

# Launch walker clipboard
walker -m clipboard 
LOG=`hyprctl clients -j`
echo $LOG > /tmp/log

# Wait for walker window to close by checking hyprctl clients
while hyprctl clients -j | jq -e '.[] | select(.class == "walker")' > /dev/null 2>&1; do
    hyprctl dispatch sendshortcut , X, address:0x55e2f09232d0
    sleep 0.2
done

# Small delay to ensure clipboard is updated
sleep 0.1

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
