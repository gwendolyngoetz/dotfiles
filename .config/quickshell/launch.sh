#! /bin/bash
# Quickshell counterpart of ~/.config/polybar/launch.sh. Interface / hwmon detection now lives in
# Env.qml, so this only restarts the shell.

pkill -x quickshell || pkill -x qs || true

# Wait until the old instance has stopped
while pgrep -u $UID -x quickshell > /dev/null || pgrep -u $UID -x qs > /dev/null; do sleep 0.2; done

setsid qs > /dev/null 2>&1 &
