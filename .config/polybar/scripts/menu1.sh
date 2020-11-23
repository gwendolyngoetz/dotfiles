#! /bin/sh

cat <<EOF | xmenu | sh &
Logout	i3-nagbar
Logout2	rxvt-unicode
Shutdown	poweroff
Reboot	reboot
EOF
