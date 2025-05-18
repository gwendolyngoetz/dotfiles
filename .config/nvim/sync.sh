#!/bin/bash

ORIGINAL_PLUGINS_ROOT_DIR="/home/gwendolyn/.local/share/nvim/lazy"
PLUGINS_ROOT_DIR="/tmp/nvim/lazy"

if [[ -d "${PLUGINS_ROOT_DIR}" ]]; then
    rm -rf "${PLUGINS_ROOT_DIR}"
fi

mkdir -p "$(dirname "${PLUGINS_ROOT_DIR}")"
cp -r "${ORIGINAL_PLUGINS_ROOT_DIR}" "${PLUGINS_ROOT_DIR}"

DIRS=( $(find "${PLUGINS_ROOT_DIR}" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort) )

for DIR in "${DIRS[@]}"; do
    pushd "${PLUGINS_ROOT_DIR}/${DIR}" > /dev/null || exit
    MASTER_BRANCH_NAME=$(git branch -l master main | sed 's/^* //')
    SHA_BEFORE="$(git rev-parse --short=7 HEAD)"
    git checkout ${MASTER_BRANCH_NAME} > /dev/null 2>&1
    git pull > /dev/null 2>&1
    SHA_AFTER="$(git rev-parse --short=7 HEAD)"
    if [[ "${SHA_BEFORE}" != "${SHA_AFTER}" ]]; then
        echo "${SHA_BEFORE} ${SHA_AFTER} ${DIR}"
    fi
    popd > /dev/null || exit
done
