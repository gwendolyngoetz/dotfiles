#!/bin/sh
#
# Output names: sway uses DRM connector names (DisplayPort-0 -> DP-1).
out1=DP-1
out2=DP-2

# wait_for_windows WS COUNT: block until workspace WS holds COUNT windows
wait_for_windows() {
    while [ "$(swaymsg -t get_tree | jq "[.. | objects | select(.type? == \"workspace\" and .num? == $1) | .. | objects | select(.pid? != null)] | length")" -lt "$2" ]; do
        sleep 0.2
    done
}

# workspace 1 (workspace-1.json): terminal | firefox, side by side
swaymsg "workspace number 1; move workspace to output $out1; layout splith"
swaymsg "workspace number 1; exec alacritty"
swaymsg "workspace number 1; exec firefox"

# workspace 6 (workspace-6.json):
swaymsg "workspace number 6; move workspace to output $out2; layout splith"
swaymsg "workspace number 6; exec firefox"
wait_for_windows 6 1

swaymsg "workspace number 6; splitv; exec firefox"
wait_for_windows 6 2
swaymsg "workspace number 6; resize set height 30 ppt"

swaymsg "workspace number 6; focus parent; exec alacritty"
wait_for_windows 6 3
swaymsg "workspace number 6; resize set width 40 ppt"

swaymsg "workspace number 1"
