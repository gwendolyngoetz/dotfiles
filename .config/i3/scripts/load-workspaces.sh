#!/bin/sh 
i3-msg "workspace 1:1; append_layout ~/.config/i3/workspaces/workspace-1.json; exec --no-startup-id alacritty --working-directory ~; exec --no-startup-id firefox;"

#sleep 1s

i3-msg "workspace 2:2; append_layout ~/.config/i3/workspaces/workspace-2.json; exec --no-startup-id firefox; exec --no-startup-id firefox; exec --no-startup-id alacritty --working-directory ~;"

i3-msg "workspace 8:8; append_layout ~/.config/i3/workspaces/workspace-8.json; exec --no-startup-id alacritty --working-directory ~;"

