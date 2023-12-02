#!/bin/bash

readonly pane_index="${1}"
readonly page_current_command="${2}"
readonly window_panes="${3}"

readonly color_fg="#8375b2"

pane_info=""

if [[ "${window_panes}" != "1" ]]; then
    pane_info=" ${page_current_command}:[${pane_index}/${window_panes}]"
fi

echo "#[fg=${color_fg},bold] ${pane_info}"
