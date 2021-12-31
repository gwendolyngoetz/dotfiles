#!/bin/bash

JSONFILE=~/.config/polybar/scripts/.weather.json
curl -s wttr.in/seattle?format=j1 -o $JSONFILE

TEMP=$(jq -r '.current_condition[0].temp_F' $JSONFILE )
WEATHERCODE=$(jq -r '.current_condition[0].weatherCode' $JSONFILE)
SUNRISE=$(jq -r '.weather[0].astronomy[0].sunrise' $JSONFILE)
SUNSET=$(jq -r '.weather[0].astronomy[0].sunset' $JSONFILE)
DATEYMD=$(jq -r '.weather[0].date' $JSONFILE)

SUNRISE=$(date --date="$DATEYMD $SUNRISE" "+%k%M")
SUNSET=$(date --date="$DATEYMD $SUNSET" "+%k%M")
CURRENT=$(date "+%k%M")
ISDAYTIME=$(($CURRENT >= $SUNRISE && $CURRENT <= $SUNSET))

case $WEATHERCODE in
    # Sunny
    113) 
        if (($ISDAYTIME == 1)); then
            WEATHERICON=
        else
            WEATHERICON=
        fi
        ;;
    # Cloudy
    116 | 119 | 122)
        if (($ISDAYTIME == 1)); then
            WEATHERICON=
        else
            WEATHERICON=
        fi
        ;;
    # Rain
    266 | 293 | 296 | 302 | 308 | 359)
        WEATHERICON=
        ;;
    # Showers
    176 | 263 | 353 | 299 | 305 | 356)
        WEATHERICON=
        ;;
    # Thunder and Lightning
    200 | 386 | 389 | 392) 
        WEATHERICON=
        ;;
    # Snow
    227 | 320 | 230 | 329 | 332 | 338 | 368 | 323 | 326 | 335 | 371 | 395)
        WEATHERICON=
        ;;
    # Sleet
    182 | 185 | 281 | 284 | 311 | 314 | 317 | 350 | 377 | 179 | 362 | 365 | 374)
        WEATHERICON=
        ;;
    # Foggy
    143 | 248 | 260) 
        WEATHERICON=
        ;;
    *) 
        WEATHERICON=
        ;;
esac
        


echo "%{F#555}$WEATHERICON%{F-}   $TEMP°F"



# Weather Code List

# https://github.com/chubin/wttr.in/blob/master/lib/constants.py

# Sunny
#    "113": "Sunny"

# Cloudy
#    "116": "PartlyCloudy"
#    "119": "Cloudy"
#    "122": "VeryCloudy"

# Thunder
#    "200": "ThunderyShowers"
#    "386": "ThunderyShowers"
#    "389": "ThunderyHeavyRain"
#    "392": "ThunderySnowShowers"

# Fog
#    "143": "Fog"
#    "248": "Fog"
#    "260": "Fog"

# Rain
#    "266": "LightRain"
#    "293": "LightRain"
#    "296": "LightRain"
#    "302": "HeavyRain"
#    "308": "HeavyRain"
#    "359": "HeavyRain"

# Showers 
#    "176": "LightShowers"
#    "263": "LightShowers"
#    "353": "LightShowers"
#    "299": "HeavyShowers"
#    "305": "HeavyShowers"
#    "356": "HeavyShowers"

# Snow
#    "227": "LightSnow"
#    "320": "LightSnow"
#    "230": "HeavySnow"
#    "329": "HeavySnow"
#    "332": "HeavySnow"
#    "338": "HeavySnow"
#    "368": "LightSnowShowers"
#    "323": "LightSnowShowers"
#    "326": "LightSnowShowers"
#    "335": "HeavySnowShowers"
#    "371": "HeavySnowShowers"
#    "395": "HeavySnowShowers"

# Sleet
#    "182": "LightSleet"
#    "185": "LightSleet"
#    "281": "LightSleet"
#    "284": "LightSleet"
#    "311": "LightSleet"
#    "314": "LightSleet"
#    "317": "LightSleet"
#    "350": "LightSleet"
#    "377": "LightSleet"
#    "179": "LightSleetShowers"
#    "362": "LightSleetShowers"
#    "365": "LightSleetShowers"
#    "374": "LightSleetShowers"

