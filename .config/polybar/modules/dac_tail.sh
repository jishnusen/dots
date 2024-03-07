#!/bin/sh

stdbuf -oL pw-top -b | sed -une '/\(^R.*\)\|\(^I.*alsa_output\)/p' \
                     | sed -ue '/^R.*alsa_output/d' \
                     | stdbuf -oL tr -s ' ' \
                     | stdbuf -oL cut -f 10,12,14 -d ' ' \
                     | stdbuf -oL awk '{ if ($3=="") { print "dead" } else { print $1 " @ " $2 "Hz"}}' \
                     | stdbuf -oL uniq \
                     | stdbuf -oL xargs -I{} \
                     /bin/sh -c '[ "{}" = "dead" ] && echo && exit;
                                 export card=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | rg "alsa.card =" | rg -o "\d+"); \
                                 export rate=$(cat "/proc/asound/card$card/pcm0p/sub0/hw_params" | grep rate | cut -f 2 -d " "); \
                                 printf "$rate Hz (%s)\n" "{}"'
