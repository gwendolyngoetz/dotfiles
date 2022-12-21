#!/bin/bash


# Weather Code List
source ~/.private-env
JSONFILE=~/.config/polybar/scripts/.weather.json
curl -s "https://api.openweathermap.org/data/3.0/onecall?lat=$OPENWEATHERMAP_LAT&lon=$OPENWEATHERMAP_LON&units=imperial&exclude=minutely&appid=$OPENWEATHERMAP_API_KEY" -o $JSONFILE
~/.config/polybar/scripts/weather/weatherwidget.py $JSONFILE
