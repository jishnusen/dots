#!/bin/sh

if [ -z "$(tmux list-clients -t cmus)" ]; then
  alacritty --class Alacritty,cmus --title "C* Music Player" -e $HOME/.local/bin/tmux_cmus.sh
else
  xdotool windowactivate $(xdotool search --class "cmus")
fi
