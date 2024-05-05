#!/bin/bash

source ~/.config/polybar/scripts/weather/.venv/bin/activate


JSONFILE=~/.config/polybar/scripts/.weather.json
~/.config/polybar/scripts/weather/weather-menu.py $JSONFILE &
