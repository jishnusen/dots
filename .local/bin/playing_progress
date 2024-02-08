#!/bin/bash

status=$(playerctl status)
if [ "$status" = "Playing" ]; then
  color="#08BDBA"
elif [ "$status" = "Paused" ]; then
  color="#BAE6FF"
else
  exit
fi

length=10
nchar=$(printf '%0.f\n' $(playerctl metadata --format "({{position}}/{{mpris:length}})*$length" | bc -l))
rem=$(expr $length - $nchar)


echo -n "%{F$color}"
head -c $nchar < /dev/zero | tr '\0' '=' | sed 'y/=/━/'
echo -n '%{F-}'
# printf '╺'
head -c $rem < /dev/zero | tr '\0' '=' | sed 'y/=/━/'
