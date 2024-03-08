#!/bin/sh

card=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | rg "alsa.card =" | rg -o "\d+");
output_rate=$(cat "/proc/asound/card$card/pcm0p/sub0/hw_params" | grep rate | cut -f 2 -d " ");

[ -z "$output_rate" ] && echo && exit

input_rates=$(pw-top -b -n2 | rg "^R.*" \
              | rg -v "alsa_output" \
              | tr -s ' ' \
              | cut -f 10,12,14 -d ' ' \
              | awk '{ s++; print $1 " @ " $2 "Hz" }' \
              | tr '\n' ',' \
              | sed 's/,$/\n/' \
              )
echo "$output_rate Hz ($input_rates)"
