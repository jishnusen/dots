#!/bin/sh

bspc subscribe node_add node_remove | while read line; do
  for wid in $(bspc query -N -d -n .window); do
    xprop -id $wid 2>&1 >/dev/null | rg "BadWindow" && bspc node $wid -k
  done
done
