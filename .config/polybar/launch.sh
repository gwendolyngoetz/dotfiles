#! /bin/bash

killall -q polybar

# Wait until the processes have stopped
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$m polybar --reload primary &
done
