#!/bin/bash
# Fetch the OpenWeatherMap one-call response into scripts/.weather.json for bar/modules/Weather.qml.
# Needs OPENWEATHERMAP_LAT / _LON / _API_KEY from ~/.private-env.

source ~/.private-env

JSONFILE=~/.config/quickshell/scripts/.weather.json
TMP="$JSONFILE.tmp"

# write to a temp file so a failed or partial download never clobbers the last good response
if curl -sf "https://api.openweathermap.org/data/3.0/onecall?lat=$OPENWEATHERMAP_LAT&lon=$OPENWEATHERMAP_LON&units=imperial&exclude=minutely&appid=$OPENWEATHERMAP_API_KEY" -o "$TMP"; then
    mv "$TMP" "$JSONFILE"
else
    rm -f "$TMP"
    exit 1
fi
