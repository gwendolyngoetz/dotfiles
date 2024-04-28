#!/bin/sh

SEARCH="${1}"

docker ps --all --format "{{.Names}}" --filter=name="${SEARCH}" | xargs docker update --restart no

