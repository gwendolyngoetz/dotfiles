#!/bin/sh
out1=DP-1
out2=DP-2

# wait (max ~10s) until output $1 is active
wait_output() {
    i=0
    until swaymsg -t get_outputs | jq -e --arg o "$1" '.[] | select(.name == $o and .active)' >/dev/null; do
        [ $i -ge 100 ] && {
            echo "timeout waiting for output $1" >&2
            return 1
        }
        sleep 0.1
        i=$((i + 1))
    done
}

# wait (max ~5s) until workspace $1 has at least $2 windows
wait_windows() {
    i=0
    while [ $i -lt 50 ]; do
        n=$(swaymsg -t get_tree | jq --arg ws "$1" \
            '[.. | objects | select(.type == "workspace" and .name == $ws) | .. | objects | select(.pid != null)] | length' 2>/dev/null)
        [ "${n:-0}" -ge "$2" ] && return 0
        sleep 0.1
        i=$((i + 1))
    done
    echo "timeout waiting for $2 windows on $1" >&2
}

# DP-1: alacritty | firefox
wait_output "$out1"
swaymsg "workspace \"1:1\"; move workspace to output $out1; layout splith"
swaymsg 'exec alacritty'
wait_windows "1:1" 1
swaymsg 'exec firefox'
wait_windows "1:1" 2

# DP-2: firefox stacked over firefox | alacritty
# Open alacritty before splitting: splitting a lone window just flips the
# workspace layout instead of wrapping it.
wait_output "$out2"
swaymsg "workspace \"6:6\"; move workspace to output $out2; layout splith"
swaymsg 'exec firefox'
wait_windows "6:6" 1
swaymsg 'exec alacritty'
wait_windows "6:6" 2
swaymsg 'focus left; splitv; exec firefox'
wait_windows "6:6" 3
swaymsg "focus up; resize set height 65 ppt"

swaymsg 'workspace "1:1"'
