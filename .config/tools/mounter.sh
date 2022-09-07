#!/bin/bash

share="$1"
server="truenas"
local_path="/mnt/nfs/${server}/${share}"
remote_path="${server}:/mnt/storage0/${share}"
green="\e[38;2;5;225;5m"
blue="\e[38;2;5;125;225m"
reset="\033[0m"

if [[ -z "${share}" ]]; then
  echo "Missing share name. Try:"
  echo ""
  exa --tree --icons /mnt/nfs
  exit 1
fi

if grep -qs "${local_path} " /proc/mounts; then
  sudo umount ${local_path}
  printf "${blue}umounted${reset}: ${local_path}\n"
else
  sudo mount -t nfs "${remote_path}" "${local_path}"
  printf "${green}mounted${reset}: ${local_path}\n"
fi
