#!/bin/bash

readonly session_name="${1}"
readonly color_fg="#8375b2"
echo "#[fg=${color_fg},bold]${session_name}"
