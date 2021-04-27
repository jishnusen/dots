#!/bin/bash

number=$(playerctl status -a | rg Play -n | cut -f 1 -d : | sed -n '1 p')
if [ -z $number ]; then
  number=$(playerctl status -a | rg Pause -n | cut -f 1 -d : | sed -n '1 p')
  if [[ -z $number ]]; then
      echo
      exit 0
  fi
fi
player=$(playerctl -l | sed -n $number' p')

playerctl $1 -p $player

