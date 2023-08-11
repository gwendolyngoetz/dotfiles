#!/bin/bash

SEARCH="${1}"

echo "Removing volumes:" 

if [[ -n "${SEARCH}" ]]; then
    docker ps --all --format "{{.Names}}" | grep "${SEARCH}"
    docker volume rm $(docker volume ls -q | grep "${SEARCH}")
else
    docker ps --all --format "{{.Names}}"
    docker volume rm $(docker volume ls -q)
fi

