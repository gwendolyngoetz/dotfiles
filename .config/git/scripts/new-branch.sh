#!/bin/bash

if [[ -z "${1}" ]]; then
    echo "Missing branch name"
    exit 1
fi

branch_name="${1}"

if [[ "${branch_name}" != *"/"* ]]; then
    branch_name="${USER:0:4}/${branch_name}"
fi

git checkout -b "${branch_name}"
