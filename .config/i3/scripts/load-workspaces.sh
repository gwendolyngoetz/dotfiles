#!/bin/sh 
i3-msg "workspace 1:1; append_layout ~/.config/i3/workspaces/workspace-1.json; exec --no-startup-id alacritty --working-directory ~; exec --no-startup-id firefox;"

#sleep 1s

i3-msg "workspace 4:4; append_layout ~/.config/i3/workspaces/workspace-4.json; exec --no-startup-id firefox; exec --no-startup-id firefox; exec --no-startup-id alacritty --working-directory ~;"

