#!/bin/sh

wid=$1
class=$2
instance=$3
consequences=$4

role=$(xprop -id $wid WM_WINDOW_ROLE | awk '{print $NF}' | tr -d '\"')

case $role in
  'pop-up')
    echo "state=floating"
    ;;
esac
