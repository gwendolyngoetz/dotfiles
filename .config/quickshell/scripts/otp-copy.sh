#! /bin/sh
# Copy the OTP for a password-store entry to the clipboard and notify.
#
# Deliberately not `pass otp --clip`: that first reads the existing clipboard (to restore it
# later) and the read blocks until the current owner answers, which delays the toast. Clear the
# clipboard ourselves after the same 45 seconds instead.

account="$1"

code="$(pass otp "$account")" || {
    notify-send -u critical -t 3000 "OTP" "Failed to generate $account code"
    exit 1
}

printf '%s' "$code" | xclip -selection clipboard
notify-send -u normal -t 1000 "OTP" "$account added to clipboard"

(
    sleep 45
    [ "$(xclip -o -selection clipboard 2>/dev/null)" = "$code" ] && printf '' | xclip -selection clipboard
) > /dev/null 2>&1 &
