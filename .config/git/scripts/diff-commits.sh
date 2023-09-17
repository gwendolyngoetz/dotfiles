#!/bin/bash

function get_commit {
    prompt_label="${1} Commit> "
    commit=$(git --no-pager log \
            --oneline \
            --color=always \
            --pretty="format:%C(auto)%h%Creset - %s %C(dim green)(%cr) %C(blue)[%an]" \
        | fzf \
            +s \
            --ansi \
            --info=hidden \
            --color="bg+:-1,prompt:4,border:#5a4799,hl:4,hl+:4,fg+:6" \
            --prompt="${prompt_label}")

    echo "${commit}" | cut -d" " -f1
}

commit_newer=$(get_commit "Newer")
if [[ -z "${commit_newer}" ]]; then
    exit 1
fi

commit_older=$(get_commit "Older")

if [[ -z "${commit_older}" ]]; then
    exit 2
fi

echo "Comparing commit ${commit_older} and ${commit_newer}"

if [[ -z "${SSH_CLIENT}" ]]; then
    git difftool -d "${commit_older}" "${commit_newer}"
else
    git diff "${commit_older}" "${commit_newer}"
fi



