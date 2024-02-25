#!/bin/sh

art_file=$(mktemp)
started=0

display() {
  if [ "$started" -ne 1 ]; then
    echo "init feh"
    feh -. --auto-reload --class art_viewer $art_file &
    feh_pid=$!
    started=1
  fi
}

cleanup () {
  echo "cleanup"
  rm $art_file
}

trap cleanup EXIT

while true
do
  art_url=$(playerctl metadata -i chromium | rg artUrl | sed 's/ \+/\t/g' | cut -f 3)
  short=$(playerctl -i chromium metadata --format '{{ playerName }}%{{ album }}%{{ artist }}%{{ title }}')
  if [ ! -z "$art_url" -a ! "$art_url" = "$art_old" ]; then
    echo load $art_url
    curl -sSL $art_url | convert - -resize 500x500 $art_file
    display
  elif [ "$(echo $short | cut -f 1 -d '%')" = "cmus" -a ! "$short" = "$short_old" ]; then
    album=$(echo $short | cut -f 2 -d '%')
    artist=$(echo $short | cut -f 3 -d '%')
    title=$(echo $short | cut -f 4 -d '%')
    art_beets=$(beet ls -p album:"$album" artist:"$artist" title:"$title" | head -n1)
    convert "$(dirname "$art_beets")/cover.{jpg,png}" -resize 500x500 $art_file
    display
  fi
  art_old=$art_url
  short_old=$short
  sleep 1
  if [ "$started" -ne 0 ]; then
    ps -p $feh_pid >/dev/null || break
  fi
done
