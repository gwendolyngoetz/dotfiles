#!/bin/bash

# Reuse the venv already built for the polybar scripts unless one exists here
VENV=~/.config/quickshell/scripts/weather/.venv
[ -d "$VENV" ] || VENV=~/.config/polybar/scripts/weather/.venv
source "$VENV/bin/activate"


JSONFILE=~/.config/quickshell/scripts/.weather.json
~/.config/quickshell/scripts/weather/weather-menu.py $JSONFILE &
