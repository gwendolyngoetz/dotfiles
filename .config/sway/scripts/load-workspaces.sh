#!/bin/sh
#
# sway port of the i3 version. Sway has no append_layout, so the swallow
# layouts in ~/.config/i3/workspaces/*.json cannot be replayed. This launches
# the same apps on the same workspace/output instead; split percentages are
# left to the apps' defaults.
#
# Output names: sway uses DRM connector names (DisplayPort-0 -> DP-1).
out1=DP-1
out2=DP-2

# workspace 1 (workspace-1.json): terminal | firefox, side by side
swaymsg "workspace number 1; move workspace to output $out1; layout splith"
swaymsg "workspace number 1; exec alacritty"
swaymsg "workspace number 1; exec firefox"

# workspace 6: the i3 script loads it onto $out2 but there is no workspace-6.json,
# so there is nothing to launch. Just place it.
swaymsg "workspace number 6; move workspace to output $out2"

swaymsg "workspace number 1"
