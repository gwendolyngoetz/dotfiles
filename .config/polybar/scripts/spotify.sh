#!/bin/bash
# modified from https://github.com/NicholasFeldman/dotfiles/blob/master/polybar/.config/polybar/spotify.sh
main() {
  if ! pgrep -x spotify >/dev/null; then
    echo ""; exit
  fi  

  cmd="org.freedesktop.DBus.Properties.Get"
  domain="org.mpris.MediaPlayer2"
  path="/org/mpris/MediaPlayer2"

  meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:${domain}.Player string:Metadata)

  artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed 's/\&/\\&/g' | sed 's#\/#\\/#g')
  title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed 's/\&/\\&/g'| sed 's#\/#\\/#g')
  result="$(echo "${*:-%title% - %artist%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g"i | cut -c1-30)"

  if [[ "${result}" == *"freedesktop"* ]]; then
    return
  fi

  echo "${result}"
}

main "$@"
