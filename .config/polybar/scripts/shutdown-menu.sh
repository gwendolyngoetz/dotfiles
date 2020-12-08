#! /bin/sh

cat <<EOF | xmenu -i | sh &
 Logout	i3-nagbar
 Reboot	reboot

 Shutdown	poweroff
EOF
