#!/usr/bin/env bash

creds="$(echo "${1}" | sed '/^$/d' | tail --lines=3)"

printf "[default]\n%s" "${creds}" > ~/.config/aws/credentials


