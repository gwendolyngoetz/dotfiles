#! /bin/sh

JSONFILE=~/.config/polybar/scripts/.weather-owm.json
TEMP=$(jq -r '.main.temp' $JSONFILE )
TEMP_HI=$(jq -r '.main.temp_max' $JSONFILE )
TEMP_LOW=$(jq -r '.main.temp_min' $JSONFILE )
HUMIDITY=$(jq -r '.main.humidity' $JSONFILE)
WEATHER=$(jq -r '.weather[0].main' $JSONFILE)
SUNRISE=$(jq -r '.sys.sunrise' $JSONFILE)
SUNSET=$(jq -r '.sys.sunset' $JSONFILE)
CITY=$(jq -r '.name' $JSONFILE)
DATEUNIX=$(jq -r '.dt' $JSONFILE)
DATEYMD=$(date --date="@$DATEUNIX" "+%b-%d")

TEMP=$(echo $TEMP | awk '{print int($1+0.5)}')
TEMP_HI=$(echo $TEMP_HI | awk '{print int($1)}')
TEMP_LOW=$(echo $TEMP_LOW | awk '{print int($1+0.5)}')
SUNRISE=$(date --date="@$SUNRISE" "+%-I:%M %p")
SUNSET=$(date --date="@$SUNSET" "+%-I:%M %p")

MENU_TEXT=" City             $CITY

 Weather      $WEATHER

 Temp            $TEMP°F	
 High              $TEMP_HI°F	
 Low               $TEMP_LOW°F	

 Humidity      $HUMIDITY%

 Date             $DATEYMD	
 Sunrise        $SUNRISE	
 Sunset         $SUNSET"


if ! xhost > /dev/null 2>&1; then
  echo "$MENU_TEXT"
else
  echo "$MENU_TEXT" | xmenu -i | sh &
fi
