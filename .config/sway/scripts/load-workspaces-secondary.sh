#!/bin/sh
#
# sway port of the i3 version. See load-workspaces.sh for why this launches
# apps directly instead of replaying the i3 layout JSON.
#
# Output names: sway uses DRM connector names (DisplayPort-0 -> DP-1).
out1=DP-1
out2=DP-2
out3=DP-3

# workspace 3 (workspace-3.json): VirtualBox Machine. A VM has to be started by
# hand, so only the workspace is placed.
swaymsg "workspace number 3; move workspace to output $out1"

# workspace 4 (workspace-4.json): slack | (teams / firefox) stacked
swaymsg "workspace number 4; move workspace to output $out2; layout splith"
swaymsg "workspace number 4; exec slack"
# Microsoft Teams is matched by title in the i3 layout; launch it however you normally do.
swaymsg "workspace number 4; exec firefox"

# workspace 9 (workspace-9.json): terminal | (terminal / terminal)
swaymsg "workspace number 9; move workspace to output $out3; layout splith"
swaymsg "workspace number 9; exec alacritty"
swaymsg "workspace number 9; exec alacritty"
swaymsg "workspace number 9; exec alacritty"
