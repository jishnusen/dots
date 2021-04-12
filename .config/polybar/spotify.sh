#!/bin/bash

main() {
  if ! pgrep -x spotify >/dev/null; then
    echo ""; exit
  fi

  artist=$(playerctl metadata artist)
  title=$(playerctl metadata title)
  status=$(playerctl status)
  shuffle=$(playerctl shuffle)
  loop=$(playerctl loop)

  # echo -n "%{A1:i3-msg workspace number 9:}%{F${ICON_COLOR}}%{F-}%{A} "
  echo -n "$artist - "
  echo -n "$title"
  echo
}

trap main USR1

while true; do
  main "$@"
  sleep 5 &
  wait $!
done
