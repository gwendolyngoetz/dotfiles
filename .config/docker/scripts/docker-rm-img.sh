#!/bin/bash

SEARCH="${1}"

echo "Removing images:" 

if [[ -n "${SEARCH}" ]]; then
    docker images --all --format "{{.Names}}:{{.Tag}}" | grep "${SEARCH}" | sort
    docker rmi -f $(docker images --all --format "{{.ID}}" | grep "${SEARCH}")

else
    docker images --all --format "{{.Names}}:{{.Tag}}" | sort
    docker rmi -f $(docker images -a -q)
fi

