#! /bin/bash
# Restart quickshell. Interface / hwmon detection lives in Env.qml.

pkill -x quickshell || pkill -x qs || true

# Wait until the old instance has stopped
while pgrep -u $UID -x quickshell > /dev/null || pgrep -u $UID -x qs > /dev/null; do sleep 0.2; done

setsid qs > /dev/null 2>&1 &
