#!/bin/bash

sketchybar --add event aerospace_mode_change

md=$(aerospace list-modes --current)

sketchybar --add item mode left \
           --set mode  \
                 script="$PLUGIN_DIR/mode.sh" \
                 label=$md \
                 background.border_color=0xffffffff \
                 background.border_width=2 \
           --subscribe mode aerospace_mode_change 
