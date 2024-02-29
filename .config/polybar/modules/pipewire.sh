sink="@DEFAULT_AUDIO_SINK@"
volume=$(wpctl get-volume $sink | awk '{ print $NF }')

case $1 in
  "--up")
    wpctl set-volume $sink 5%+
    ;;
  "--down")
    wpctl set-volume $sink 5%-
    ;;
  "--mute")
    wpctl set-mute $sink toggle
    ;;
  *)
    case $volume in
      "[MUTED]")
        echo "%{F$CAT_OVERLAY0}󰖁%{F-} "
        ;;
      *)
        echo -n "%{F$CAT_GREEN}󰕾%{F-} "
        printf %.0f $(echo "100*$volume" | bc)
        echo "%"
    esac
esac
