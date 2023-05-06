#!/bin/bash

readonly window_index="${1}"
readonly window_name="${2}"
readonly window_flags="${3}"

readonly color_active="#7aa2f7"
readonly color_prev="#aeaeb7"
readonly color_inactive="#616165"
readonly color_background="#282936"

icon=""
pill_open=""
pill_close=""
pill_color=""

case "${window_flags}" in
    '*')
        pill_open="#[fg=${color_active} bg=${color_background}]"
        pill_close="#[fg=${color_active} bg=${color_background}]"
        pill_color="#[fg=${color_background} bg=${color_active}]"
        ;;
    '-')
        pill_open="#[fg=${color_prev} bg=${color_background}]"
        pill_close="#[fg=${color_prev} bg=${color_background}]"
        pill_color="#[fg=${color_background} bg=${color_prev}]"
        ;;
    '')
        pill_open="#[fg=${color_inactive} bg=${color_background}]"
        pill_close="#[fg=${color_inactive} bg=${color_background}]"
        pill_color="#[fg=${color_background} bg=${color_inactive}]"
        ;;
esac

case "${window_name}" in
    bash)
        icon="";;
    nvim|vim|vi)
        icon="";;
    python)
        icon="";;
    *)
        icon="${window_name}";;
esac

echo "${pill_open}${pill_color} ${window_index} ${icon} ${pill_close}"

