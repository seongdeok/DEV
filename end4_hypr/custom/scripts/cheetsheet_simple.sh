#!/bin/bash

# Function to convert modmask to human-readable modifier keys
modmask_to_mods() {
    local modmask=$1
    local mods=()
    
    # Hyprland modmask values:
    # 1 = Shift, 4 = Ctrl, 8 = Alt, 64 = Super
    [[ $((modmask & 1)) -ne 0 ]] && mods+=("Shift")
    [[ $((modmask & 4)) -ne 0 ]] && mods+=("Ctrl") 
    [[ $((modmask & 8)) -ne 0 ]] && mods+=("Alt")
    [[ $((modmask & 64)) -ne 0 ]] && mods+=("Super")
    
    # Join with +
    local IFS="+"
    echo "${mods[*]}"
}

echo "=== Hyprland Keybindings Cheatsheet ==="
echo "Generated from actual loaded configuration via hyprctl"
echo ""

# Get keybindings and format them
hyprctl binds | awk '
BEGIN { 
    in_bind = 0
    modmask = ""
    key = ""
    description = ""
    dispatcher = ""
    arg = ""
}
/^bind[a-z]*$/ {
    in_bind = 1
    next
}
in_bind && /^\tmodmask: / {
    modmask = $2
    next
}
in_bind && /^\tkey: / {
    sub(/^\tkey: /, "")
    key = $0
    next
}
in_bind && /^\tdescription: / {
    sub(/^\tdescription: /, "")
    description = $0
    next
}
in_bind && /^\tdispatcher: / {
    sub(/^\tdispatcher: /, "")
    dispatcher = $0
    next
}
in_bind && /^\targ: / {
    sub(/^\targ: /, "")
    arg = $0
    
    # Process the binding - show all bindings except global dispatchers
    if (key != "" && key != "Super_L" && dispatcher != "global") {
        # Use the command as description if no description provided
        if (description == "") {
            if (dispatcher == "exec") {
                description = arg
            } else {
                description = dispatcher " " arg
            }
        }
        print modmask "|" key "|" description "|" dispatcher "|" arg
    }
    
    # Reset for next binding
    in_bind = 0
    modmask = ""
    key = ""
    description = ""
    dispatcher = ""
    arg = ""
    next
}
/^$/ {
    in_bind = 0
}
' | while IFS="|" read -r modmask key description dispatcher arg; do
    # Convert modmask to readable modifiers
    mods=$(modmask_to_mods "$modmask")
    
    # Format key combination
    if [[ -n "$mods" ]]; then
        keycombo="$mods+$key"
    else
        keycombo="$key"
    fi
    
    # Print formatted line
    printf "%-30s %s\n" "$keycombo" "$description"
done | sort -u

echo ""
echo "Total keybindings: $(hyprctl binds | awk '/^bind[a-z]*$/ {count++} END {print count+0}')"
