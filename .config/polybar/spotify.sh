#!/bin/bash

main() {
  # if ! pgrep -x spotify >/dev/null; then
  #   echo ""; exit
  # fi

  playerctl status -a &> /dev/null
  if ! [ "$?" -eq "0" ]; then
    echo
    exit 0
  fi

  number=$(playerctl status -a | rg Play -n | cut -f 1 -d : | sed -n '1 p')
  if [ -z $number ]; then
      number=$(playerctl status -a | rg Pause -n | cut -f 1 -d : | sed -n '1 p')
      if [[ -z $number ]]; then
          echo
          exit 0
      fi
  fi
  player=$(playerctl -l | sed -n $number' p')
  artist=$(playerctl metadata artist -p $player | cut -f 1 -d ";")
  title="`playerctl metadata title -p $player | cut -c -30``playerctl metadata title -p $player| awk 'length>20{print "..."; exit}1' | xargs`"
  status=$(playerctl status -p $player | rg Playing)
  # shuffle=$(playerctl shuffle)
  # loop=$(playerctl loop)

  BUTTON_COLOR="$(xgetres color5)"
  ICON_COLOR="$(xgetres color13)"
  ARTIST_COLOR="$(xgetres color14)"

  pp=
  if [ "${status}" = "Playing" ]; then
    pp="%{F${BUTTON_COLOR}}%{F-}"
  fi


  # ss="%{A1:spotify-refresh $$ playerctl shuffle Off:}%{A}"
  # if [ "${shuffle}" = "Off" ]; then
  #   ss="%{A1:spotify-refresh $$ playerctl shuffle On:}%{F${BUTTON_COLOR}}%{F-}%{A}"
  # fi

  # ll="%{A1:spotify-refresh $$ playerctl loop None:}%{A}"
  # if [ "${loop}" = "None" ]; then
  #   ll="%{A1:spotify-refresh $$ playerctl loop Playlist:}%{F${BUTTON_COLOR}}%{F-}%{A}"
  # fi

  echo -n "%{A1:wmctrl -a \`playerctl metadata artist\`:}%{F${ICON_COLOR}}%{F-}%{A} "
  echo -n "$artist %{F${BUTTON_COLOR}}-%{F-} "
  echo -n "%{F${ARTIST_COLOR}}$title%{F-}"
  echo -n " %{A1:spotify-refresh $$ playerctl previous -p $player:}%{A} "
  echo -n "%{A1:spotify-refresh $$ playerctl play-pause -p $player:} $pp %{A} "
  echo -n "%{A1:spotify-refresh $$ playerctl next -p $player:}%{A} "
  # echo -n " "
  # echo -n "$ss "
  # echo -n "$ll"
  echo
  # echo $status
}

# trap main USR1

# while true; do
  main "$@"
  # sleep 5 &
  # wait $!
# done


##!/bin/bash

#main() {
#  artist=$(playerctl metadata artist)
#  title=$(playerctl metadata title)
#  status=$(playerctl status)
#  shuffle=$(playerctl shuffle)
#  loop=$(playerctl loop)

#  echo -n "%{A1:i3-msg workspace number 9:}%{F${ICON_COLOR}}%{F-}%{A} "
#  echo -n "$artist - "
#  echo -n "$title"
#  echo
#}

#main "$@"
