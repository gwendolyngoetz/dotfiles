#! /bin/sh

cat <<EOF | xmenu -i | sh &
 Logout	i3-msg exit
 Sleep	systemctl suspend

 Reboot	reboot

 Shutdown	poweroff
EOF
