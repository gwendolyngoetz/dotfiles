#!/bin/sh

while pgrep -u $UID -x dunst > /dev/null; do sleep 1; done

dunst -config ~/.config/dunst/dunstrc
