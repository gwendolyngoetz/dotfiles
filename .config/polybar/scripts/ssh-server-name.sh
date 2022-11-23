#! /bin/sh


windowpid=$(xdotool getactivewindow getwindowpid)
sshpid=$(pstree -p $windowpid | grep -e "-ssh(" | awk -F 'ssh' '{print $2}' | sed 's/^.//;s/.$//')

if test -z "$sshpid"; then
    echo ""
    exit
fi

servername=$(ps -o command --pid $sshpid | tail --lines 1 | cut -d' ' -f2)

echo "%{F#555}%{F-} $servername"

