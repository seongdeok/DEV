#!/bin/sh

cur_workspace=`aerospace list-workspaces --focused`
echo $cur_workspace
cur_windows_count=`aerospace list-windows --workspace $cur_workspace --count`
echo $cur_windows_count

for((i=0; i<cur_windows_count; i++)); do 
  echo "Hello"
  aerospace move left
done

cnt=$((cur_windows_count /2))
for((i=0; i<cnt; i++)); do 
  echo "Hello ddd"
  #aerospace move right
done

