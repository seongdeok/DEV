#!/bin/bash

echo "aerospace mode changed"

md=$(aerospace list-modes --current)

sketchybar --set mode  \
                 label=$md
