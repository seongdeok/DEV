#!/bin/bash

# Function to convert modmask to human-readable modifier keys
modmask_to_mods() {
    local modmask=$1
    local mods=()
    
    # Hyprland modmask values:
    # 1 = Shift, 4 = Ctrl, 8 = Alt, 64 = Super
    # Combinations are additive (e.g., 68 = Ctrl+Super)
    
    [[ $((modmask & 1)) -ne 0 ]] && mods+=("Shift")
    [[ $((modmask & 4)) -ne 0 ]] && mods+=("Ctrl") 
    [[ $((modmask & 8)) -ne 0 ]] && mods+=("Alt")
    [[ $((modmask & 64)) -ne 0 ]] && mods+=("Super")
    
    # Join with +
    local IFS="+"
    echo "${mods[*]}"
}

# Get keybindings from hyprctl and format them
mapfile -t BINDINGS < <(
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
            # Determine if we have a real description or need to generate one
            has_real_desc = (description != "")
            
            # Use the command as description if no description provided
            if (description == "") {
                if (dispatcher == "exec") {
                    description = arg
                } else {
                    description = dispatcher " " arg
                }
            }
            
            # Add priority prefix: 0 for real descriptions, 1 for generated ones
            priority = has_real_desc ? "0" : "1"
            print priority "|" modmask "|" key "|" description "|" dispatcher "|" arg
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
    ' | while IFS="|" read -r priority modmask key description dispatcher arg; do
        # Convert modmask to readable modifiers
        mods=$(modmask_to_mods "$modmask")
        
        # Format key combination
        if [[ -n "$mods" ]]; then
            keycombo="$mods+$key"
        else
            keycombo="$key"
        fi
        
        # Format for rofi with embedded command data (using @@ as delimiter)
        # Include priority for sorting but don't show it
        printf "%s|%-30s %s@@%s@@%s\n" "$priority" "$keycombo" "$description" "$dispatcher" "$arg"
    done | sort -t'|' -k1,1n -k2,2 | cut -d'|' -f2-
)

# Use rofi to display and select keybinding
CHOICE=$(printf '%s\n' "${BINDINGS[@]}" | rofi -dmenu -i -p "Hyprland Keybinds:" -theme-str 'window {width: 80%;}')

if [[ -n "$CHOICE" ]]; then
    # Extract dispatcher and arg from the choice (using @@ as delimiter)
    DISPATCHER=$(echo "$CHOICE" | sed -n 's/.*@@\([^@]*\)@@\([^@]*\)$/\1/p')
    ARG=$(echo "$CHOICE" | sed -n 's/.*@@\([^@]*\)@@\([^@]*\)$/\2/p')
    
    # Execute the command
    if [[ "$DISPATCHER" == "exec" ]]; then
        eval "$ARG"
    else
        hyprctl dispatch "$DISPATCHER" "$ARG"
    fi
fi