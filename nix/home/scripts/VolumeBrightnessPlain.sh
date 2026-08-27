#!/usr/bin/env bash

volume_step=2
brightness_step=5
max_volume=100
max_brightness=$(brightnessctl m)

function get_volume {
    pamixer --get-volume
}

function get_mute {
    pamixer --get-mute
}

function get_brightness {
    brightnessctl g
}

case $1 in
    volume_up)
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pamixer --set-volume $max_volume
    else
        pamixer -i $volume_step
    fi
    ;;

    volume_down)
    pamixer -d $volume_step
    ;;

    volume_mute)
    pamixer -t
    ;;

    brightness_up)
    brightnessctl s "$brightness_step%+"
    ;;

    brightness_down)
    brightnessctl s "$brightness_step%-"
    ;;
esac
