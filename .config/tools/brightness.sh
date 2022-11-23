#!/bin/bash

ACTION="${1}"

BRIGHTNESS=1.0
CURRENT_BRIGHTNESS=$(xrandr --verbose | grep -m 1 -i brightness | cut -d' ' -f2)

if [[ "${ACTION}" == "toggle" ]] && [[ "$CURRENT_BRIGHTNESS" == "1.0" ]]; then
  ACTION="dim"  
elif [[ "${ACTION}" == "toggle" ]] && [[ "$CURRENT_BRIGHTNESS" != "1.0" ]]; then
  ACTION="full"  
fi

if [[ "${ACTION}" == "dim" ]]; then
    BRIGHTNESS=0.7
elif [[ "${ACTION}" == "full" ]]; then
    BRIGHTNESS=1.0
elif [[ "${ACTION}" == "inc" ]]; then
    BRIGHTNESS=$(bc <<< "$CURRENT_BRIGHTNESS+0.1")
elif [[ "${ACTION}" == "dec" ]]; then
    BRIGHTNESS=$(bc <<< "$CURRENT_BRIGHTNESS-0.1")
else
    echo "Use 'dim', 'full', 'inc', 'dec', or 'toggle' only"
    exit 1
fi

if [[ $(bc <<< "${BRIGHTNESS} < 0") == 1 ]]; then
  exit 2
fi

if [[ $(bc <<< "${BRIGHTNESS} > 1") == 1 ]]; then
  exit 3
fi

for DISPLAY_NAME in $(xrandr -q | egrep "(^DisplayPort)" | cut -d' ' -f1); do
    xrandr --output $DISPLAY_NAME --brightness $BRIGHTNESS
done

exit 0

