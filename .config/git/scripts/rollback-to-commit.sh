#!/bin/bash

function get_commit {
    prompt_label="Commit> "

    preview_window_position="right,border-left"

    if [[ $(tput cols) -lt 120 ]]; then
        preview_window_position="up,border-bottom"
    fi

    commit=$(git --no-pager log \
            --oneline \
            --color=always \
            --pretty="format:%C(auto)%h%Creset - %s %C(blue)[%an]" \
        | fzf \
            +s \
            --ansi \
            --info=hidden \
            --bind='ctrl-u:change-preview-window(up,border-bottom)' \
            --bind='ctrl-r:change-preview-window(right,border-left)' \
            --color="bg+:-1,prompt:4,border:#5a4799,hl:4,hl+:4,fg+:6" \
            --preview="echo {} | cut -d' ' -f1 | xargs git show --quiet --color=always --pretty='fuller'" \
            --preview-window="${preview_window_position}:wrap" \
            --prompt="${prompt_label}")

    echo "${commit}" | cut -d" " -f1
}

extra_cmds=()

if [[ "${1}" == "--hard" ]]; then
    extra_cmds=(--hard)
fi

commit=$(get_commit)

if [[ -z "${commit}" ]]; then
    echo "No commit selected"
    exit 1
fi

git reset "${commit}" "${extra_cmds[@]}"
