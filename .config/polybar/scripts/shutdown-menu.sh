#! /bin/sh

cat <<EOF | xmenu -i | sh &
 Logout	i3-msg exit
 Reboot	reboot

 Shutdown	poweroff
EOF
