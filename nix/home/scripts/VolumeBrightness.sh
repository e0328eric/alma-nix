#!/usr/bin/env bash

bar_color="#7f7fff"
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

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$mute" == "yes" ]; then
        volume_icon="MUTE"
    elif [ "$volume" -lt 10 ]; then
        volume_icon=" "
    elif [ "$volume" -lt 50 ]; then
        volume_icon=" "
    else
        volume_icon=" "
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_brightness_icon {
    brightness_icon=" "
}

# Displays a volume notification using dunstify
function show_volume_notif {
    volume=$(get_mute)
    get_volume_icon
    dunstify -i audio-volume-muted-blocking -t 1000 -r 2593 -u normal "$volume_icon $volume%" -h int:value:$volume -h string:hlcolor:$bar_color
}

# Displays a brightness notification using dunstify
function show_brightness_notif {
    brightness_raw=$(get_brightness)
    brightness=$(( brightness_raw * 100 / max_brightness ))
    get_brightness_icon
    dunstify -t 1000 -r 2593 -u normal "$brightness_icon $brightness%" -h int:value:$brightness -h string:hlcolor:$bar_color
}

case $1 in
    volume_up)
    volume=$(get_volume)
    if [ $(( "$volume" + "$volume_step" )) -gt $max_volume ]; then
        pamixer --set-volume $max_volume
    else
        pamixer -i $volume_step
    fi
    show_volume_notif
    ;;

    volume_down)
    pamixer -d $volume_step
    show_volume_notif
    ;;

    volume_mute)
    pamixer -t
    show_volume_notif
    ;;

    brightness_up)
    brightnessctl s "$brightness_step%+"
    show_brightness_notif
    ;;

    brightness_down)
    brightnessctl s "$brightness_step%-"
    show_brightness_notif
    ;;
esac
