#!/bin/sh

app=$1
title=$2

if [ -z "$(tmux list-clients -t $app)" ]; then
  st -c $app -t "$title" /bin/sh -c "tmux new -As $app \"$app\"\; set -g status off"
else
  xdotool windowactivate $(xdotool search --class $1)
fi
