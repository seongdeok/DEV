#!/bin/bash
# Test version that shows output instead of launching rofi

source /home/duk0669/.config/hypr/custom/scripts/cheetsheet.sh

# Show the first 10 entries that would be sent to rofi
echo "=== Sample entries for rofi ==="
printf '%s\n' "${BINDINGS[@]}" | head -10

echo ""
echo "=== Total entries: $(printf '%s\n' "${BINDINGS[@]}" | wc -l) ==="
