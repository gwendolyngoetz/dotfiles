#!/bin/bash

readonly session_name="${1}"
readonly pane_index="${2}"
readonly window_panes="${3}"

readonly color_fg="#8375b2"

pane_info=""

if [[ "${window_panes}" != "1" ]]; then
    pane_info=" [${pane_index}:${window_panes}]"
fi

echo "#[fg=${color_fg},bold]${session_name}${pane_info} "
