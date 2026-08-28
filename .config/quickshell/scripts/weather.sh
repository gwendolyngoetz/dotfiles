#!/bin/bash


# Reuse the venv already built for the polybar scripts unless one exists here
VENV=~/.config/quickshell/scripts/weather/.venv
[ -d "$VENV" ] || VENV=~/.config/polybar/scripts/weather/.venv
source "$VENV/bin/activate"

# Weather Code List
source ~/.private-env
JSONFILE=~/.config/quickshell/scripts/.weather.json
curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=$OPENWEATHERMAP_LAT&lon=$OPENWEATHERMAP_LON&units=imperial&exclude=minutely&appid=$OPENWEATHERMAP_API_KEY" -o $JSONFILE
~/.config/quickshell/scripts/weather/weatherwidget.py $JSONFILE
