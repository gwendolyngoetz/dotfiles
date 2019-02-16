#! /bin/bash

killall -q polybar

export ETHERNET_INT=$(ls --ignore lo --ignore w* /sys/class/net)
export WIFI_INT=$(ls --ignore lo --ignore e* /sys/class/net)

# Wait until the processes have stopped
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar --reload main &
	#MONITOR=$m polybar --reload primary &
	#MONITOR=$m polybar --reload secondary &
done
