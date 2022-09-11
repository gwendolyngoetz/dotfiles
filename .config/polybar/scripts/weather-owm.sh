#!/bin/bash

# Weather Code List
# https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2 
source ~/.private-env
JSONFILE=~/.config/polybar/scripts/.weather-owm.json
curl -s "https://api.openweathermap.org/data/2.5/weather?lat=$OPENWEATHERMAP_LAT&lon=$OPENWEATHERMAP_LON&units=imperial&appid=$OPENWEATHERMAP_API_KEY" -o $JSONFILE

TEMP=$(jq -r '.main.temp' $JSONFILE )
WEATHERCODE=$(jq -r '.weather[0].id' $JSONFILE)
SUNRISE=$(jq -r '.sys.sunrise' $JSONFILE)
SUNSET=$(jq -r '.sys.sunset' $JSONFILE)
DATEUNIX=$(jq -r '.dt' $JSONFILE)
DATEYMD=$(date --date="@$DATEUNIX" "+%Y-%m-%d")

TEMP=$(echo $TEMP | awk '{print int($1+0.5)}')
SUNRISE=$(date --date="@$SUNRISE" "+%k%M")
SUNSET=$(date --date="@$SUNSET" "+%k%M")
CURRENT=$(date "+%k%M")
ISDAYTIME=$(($CURRENT >= $SUNRISE && $CURRENT <= $SUNSET))

#echo "----"
#echo $TEMP
#echo $WEATHERCODE
#echo $SUNRISE
#echo $SUNSET
#echo $DATEYMD
#echo "----"

case $WEATHERCODE in
    # Clear
    800) 
        if (($ISDAYTIME == 1)); then
            WEATHERICON=
        else
            WEATHERICON=
        fi
        ;;
    # Cloudy
    801 | 802 | 803 | 804)
        if (($ISDAYTIME == 1)); then
            WEATHERICON=
        else
            WEATHERICON=
        fi
        ;;
    # Rain
    500 | 501 | 502 | 503 | 504 | 511 | 520 | 521 | 522 | 531)
        WEATHERICON=
        ;;
    # Showers
    300 | 301 | 302 | 310 | 311 | 312 | 313 | 314 | 321)
        WEATHERICON=
        ;;
    # Thunder and Lightning
    200 | 201 | 202 | 210 | 211 | 212 | 221 | 230 | 231 | 232) 
        WEATHERICON=
        ;;
    # Snow
    600 | 601 | 602 | 611 | 612 | 613 | 615 | 616 | 620 | 621 | 622)
        WEATHERICON=
        ;;
    # Foggy
    701 | 741) 
        WEATHERICON=
        ;;
    *) 
        WEATHERICON=
        ;;
esac
        


echo "%{F#555}$WEATHERICON%{F-} $TEMP°F"



