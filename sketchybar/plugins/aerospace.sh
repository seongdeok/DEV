#!/bin/bash

echo "1=>>$FOCUSED_WORKSPACE| $NAME" >> /tmp/log.txt
echo "2=>>$1" >> /tmp/log.txt
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi

