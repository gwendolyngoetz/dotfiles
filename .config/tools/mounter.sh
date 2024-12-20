#!/bin/bash

DEFAULT_SERVER="truenas"
DEFAULT_SHARE="Documents"

COLOR_GREEN="\e[38;2;5;225;5m"
COLOR_BLUE="\e[38;2;5;125;225m"
COLOR_RESET="\033[0m"

function run_mount {
    echo "Server:"
    SERVER=$(gum choose --selected="${DEFAULT_SERVER}" $(ls "/mnt/nfs"))
    echo "Share:"
    SHARES=($(gum choose --no-limit --selected="${DEFAULT_SHARE}" $(ls "/mnt/nfs/${SERVER}")))
    for i in "${!SHARES[@]}"; do
        SHARE="${SHARES[$i]}"
        LOCAL_PATH="/mnt/nfs/${SERVER}/${SHARE}"
        POOLNAME="$(get_pool_name ${SERVER})"
        REMOTE_PATH="${SERVER}:/mnt/${POOLNAME}${SHARE}"
        printf "%bmounted%b: %b\n" "${COLOR_GREEN}" "${COLOR_RESET}" "${LOCAL_PATH}"
        sudo mount -t nfs "${REMOTE_PATH}" "${LOCAL_PATH}"
    done
}

function run_unmount {
    echo "Share:"
    TO_UNMOUNT=($(gum choose --no-limit $(grep "/mnt/nfs" /proc/mounts | cut -d' ' -f2)))
    for i in "${!TO_UNMOUNT[@]}"; do
        sudo umount "${TO_UNMOUNT[$i]}"
        printf "%bunmounted%b: %b\n" "${COLOR_BLUE}" "${COLOR_RESET}" "${TO_UNMOUNT[$i]}"
    done
}

function run_default {
    grep "/mnt/nfs" /proc/mounts | cut -d' ' -f2
}

function get_pool_name {
    local server="${1}"
    local result=""

    case "${server}" in
        "truenas")
            result="storage0/" ;;
        "nas1")
            result="main-pool/" ;;
        *)
            result="";;
    esac

    echo "${result}"
}

function main {
    echo "Action:"

    case "$(gum choose --selected=mount mount unmount show)" in
        "mount")
            run_mount;;
        "unmount")
            run_unmount;;
        *)
            run_default;;
    esac
}


main
