#!/bin/bash

SEARCH="${1}"

echo "Stopping containers:" 

if [[ -n "${SEARCH}" ]]; then
    docker ps --all --format "{{.Names}}" | grep "${SEARCH}"
    docker stop $(docker ps --all --format "{{.Names}} {{.ID}}" | grep "${SEARCH}" | cut -d" " -f2)
else
    docker ps --all --format "{{.Names}}"
    docker stop $(docker ps -q)
fi

