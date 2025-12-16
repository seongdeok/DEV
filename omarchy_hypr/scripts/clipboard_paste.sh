#!/bin/zsh
# Walker clipboard manager with smart auto-paste

# Get the active window class before opening walker
active_class=$(hyprctl activewindow -j | jq -r '.class')

# Launch walker clipboard and wait for it to finish
walker -m clipboard

# Wait for walker to fully close
while pgrep -x walker > /dev/null 2>&1; do
    sleep 0.05
done

# Give time for focus to return to the original window
sleep 0.2

# Check if it's a terminal and send appropriate paste shortcut
case "$active_class" in
    *kitty*|*alacritty*|*wezterm*|*foot*|*ghostty*|*term*)
        # Terminal: use Ctrl+Shift+V
        hyprctl dispatch sendshortcut CTRL+SHIFT, V,
        ;;
    *)
        # Other apps: use Ctrl+V
        hyprctl dispatch sendshortcut CTRL, V,
        ;;
esac
