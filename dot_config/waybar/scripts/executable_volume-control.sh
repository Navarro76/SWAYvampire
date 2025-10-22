#!/bin/bash
case "$1" in
    --up)
        wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    --down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    --toggle)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac
