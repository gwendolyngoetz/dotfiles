#!/bin/sh

for item in $(ls ~/.password-store/ | sort); do
    printf " ${item%.*}\tpass otp ${item%.*} --clip\n"
done | xmenu | sh &
