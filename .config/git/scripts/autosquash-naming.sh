#!/bin/bash

mode=$1

if [[ "$mode" == "fixup" ]]; then
    prefix="fixup!"
elif [[ "$mode" == "squash" ]]; then
    prefix="squash!"
else
    echo "Usage: git-fix.sh [fixup|squash]" >&2
    exit 1
fi

# Get the subject of the last commit
msg=$(git log --format='%s' -1 HEAD)

# If the message already has a fixup/squash prefix, strip it before reapplying
if [[ "$msg" =~ ^(fixup|squash)!\  ]]; then
    msg="${msg#*! }"
fi

git commit -m "$prefix $msg"
