#!/bin/sh

card=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | rg "alsa.card =" | rg -o "\d+")
rate="$(cat /proc/asound/card$card/pcm0p/sub0/hw_params | grep rate | cut -f 2 -d ' ')"
depth="$(cat /proc/asound/card$card/pcm0p/sub0/hw_params | grep format | sed 's/[^0-9]*//g')"

if [ ! -z "$rate" ]; then
  echo "$rate Hz ($depth bit)"
else
  echo
fi
