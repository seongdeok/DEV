#!/bin/bash

id=$(aerospace list-windows --all | grep Firefox | head -n 1 | awk -F '|' '{print $1}' | xargs)
echo $id

