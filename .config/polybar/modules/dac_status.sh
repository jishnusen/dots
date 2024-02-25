#!/bin/sh

card=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | rg "alsa.card =" | rg -o "\d+")
rate="$(cat /proc/asound/card$card/pcm0p/sub0/hw_params | grep rate | cut -f 2 -d ' ')"
# app_rate="$(pw-dump | jq 'map(select(.type == "PipeWire:Interface:Node" and .info.props."application.name"))' | jq '.[].info.params.Format | select( . != null ) | .[].rate' -r | paste -sd,)"
# depth="$(pw-dump | jq 'map(select(.type == "PipeWire:Interface:Node" and .info.props."application.name"))' | jq '.[].info.params.Format | select( . != null ) | .[].format' -r | rg -o '\d+' | sort -n | head -n1)"

if [ ! -z "$rate" ]; then
  echo "${rate}Hz"
else
  echo
fi
