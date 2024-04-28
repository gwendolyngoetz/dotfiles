#! /bin/bash

killall -q polybar

export ETHERNET_INT=$(ip -o link show | grep "state UP" | cut -d' ' -f2 | cut -d':' -f1)
export WIFI_INT=$(ls --ignore lo --ignore e* --ignore docker* /sys/class/net)

# The hwmon# directory keeps changing on reboot. Find the right folder and build the path manually
temperature_dir=$(find /sys/class/hwmon/* -maxdepth 1 -exec grep -rw --include=name "{}/" -l -e "k10temp" \; | xargs dirname)
export TEMPERATURE_PATH="$temperature_dir/temp1_input"

# Wait until the processes have stopped
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Add main bar to both displays
for m in $(xrandr --query | grep -E "(connected primary [0-9])|(connected [0-9])" | cut -d' ' -f1); do
	MONITOR=$m polybar --reload main &
done

# Add tray bar to first display
for m in $(xrandr --query | grep -E "connected primary [0-9]" | cut -d' ' -f1 | head -n 1); do
    MONITOR=$m polybar --reload secondary &
done 
