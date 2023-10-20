#!/bin/bash

readonly window_index="${1}"
readonly window_name="${2}"
readonly window_flags="${3}"

readonly color_active="#7aa2f7"
readonly color_inactive="#616165"

icon=""
section_color=""

case "${window_flags}" in
    '*')
        section_color="#[fg=${color_active}]";;
    '-'|'')
        section_color="#[fg=${color_inactive}]";;
esac

case "${window_name}" in
    bash)
        icon="";;
    nvim|vim|vi)
        icon="";;
    python)
        icon="󰌠";;
    *)
        icon="${window_name}";;
esac

echo "${section_color} ${window_index} ${icon} "

