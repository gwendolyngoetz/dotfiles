#!/bin/bash

SEARCH="${1}"

echo "Removing these containers:" 

if [[ -n "${SEARCH}" ]]; then
    docker ps --format "{{.Names}}" | grep "${SEARCH}"
    docker rm -f $(docker ps --format "{{.Names}} {{.ID}}" | grep "${SEARCH}" | cut -d" " -f2)
else
    docker ps --format "{{.Names}}"
    docker rm -f $(docker ps -a -q)
fi

