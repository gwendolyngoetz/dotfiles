#!/bin/bash

SEARCH="${1}"

echo "Removing these containers:" 

if [[ -n "${SEARCH}" ]]; then
    docker ps --all --format "{{.Names}}" | grep "${SEARCH}"
    docker rm -f $(docker ps --all --format "{{.Names}} {{.ID}}" | grep "${SEARCH}" | cut -d" " -f2)
else
    docker ps --all --format "{{.Names}}"
    docker rm -f $(docker ps -q)
fi

