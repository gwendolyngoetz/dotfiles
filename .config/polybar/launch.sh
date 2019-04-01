#! /bin/bash

killall -q polybar

export ETHERNET_INT=$(ls --ignore lo /sys/class/net)
export WIFI_INT=$(ls --ignore lo --ignore e* /sys/class/net)

# Wait until the processes have stopped
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Add main bar to both displays
for m in $(xrandr --query | grep -w connected | cut -d' ' -f1); do
	MONITOR=$m polybar --reload main &
	#MONITOR=$m polybar --reload primary &
done

# Add tray bar to first display
for m in $(xrandr --query | grep -w connected | cut -d' ' -f1 | head -n 1); do
    MONITOR=$m polybar --reload secondary &
done 
