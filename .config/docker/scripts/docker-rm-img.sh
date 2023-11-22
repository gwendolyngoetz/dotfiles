#!/bin/bash

SEARCH="${1}"

echo "Removing images:" 

if [[ -n "${SEARCH}" ]]; then
    docker images --all --format "{{.Repository}}:{{.Tag}}" | grep "${SEARCH}" | sort
    docker rmi -f $(docker images --all --format "{{.ID}}|{{.Repository}}" | grep "${SEARCH}" | cut -d'|' -f1)

else
    docker images --all --format "{{.Repository}}:{{.Tag}}" | sort
    docker rmi -f $(docker images --all -q)
fi
