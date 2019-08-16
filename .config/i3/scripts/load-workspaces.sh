#!/bin/sh 
i3-msg "workspace 1:1; append_layout ~/.config/i3/workspaces/workspace-1.json; exec --no-startup-id urxvt -cd ~; exec --no-startup-id firefox;"

sleep 1s

i3-msg "workspace 2:2; append_layout ~/.config/i3/workspaces/workspace-2.json; exec --no-startup-id firefox --new-window https://youtube.com/feed/subscriptions; exec --no-startup-id firefox --new-window https://messaging.gwendolyngoetz.com; exec --no-startup-id urxvt -cd ~;"

