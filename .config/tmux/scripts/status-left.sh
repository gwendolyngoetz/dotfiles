#!/bin/bash

readonly session_name="${1}"
readonly pane_index="${2}"

readonly color_fg="#bb9af7"
readonly color_bg="#282936"

#readonly pill_open="#[fg=${color_fg} bg=${color_bg}]"
readonly pill_close="#[fg=${color_fg} bg=${color_bg}]"
readonly pill_color="#[fg=${color_bg} bg=${color_fg}]"
readonly pill_clear="#[fg=${color_fg} bg=${color_bg}]"

readonly session_pill="${pill_color} ${session_name}${pill_clear}"
readonly pane_pill="${pill_color}:${pane_index}${pill_close}${pill_clear}"

echo "${session_pill}${pane_pill} ${pill_clear}"
