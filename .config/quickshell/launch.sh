#! /bin/bash
# Restart quickshell. Interface / hwmon detection lives in Env.qml.

# ask the running instance to exit; fall back to pkill for instances qs cannot see
qs kill > /dev/null 2>&1 || pkill -x quickshell || pkill -x qs || true

# wait until the old instance has stopped
while pgrep -u "$UID" -x quickshell > /dev/null || pgrep -u "$UID" -x qs > /dev/null; do sleep 0.2; done

# daemonize; logs go to qs's log directory (`qs log` to read them)
qs --daemonize
