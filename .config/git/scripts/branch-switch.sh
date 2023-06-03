#!/bin/bash

branch_args=()

if [[ "${1}" == "-r" ]]; then
    branch_args=(-r) 
fi

branch_name=$(git branch "${branch_args[@]}" \
    | sed 's/\ \+/ /g' \
    | cut -d' ' -f2 \
    | sed 's/^origin\///g' \
    | grep -v "HEAD" \
    | sort \
    | fzf \
        +s \
        --border=rounded \
        --margin=0,25% \
        --padding=1,0 \
        --height=40% \
        --info=hidden \
        --select-1 \
        --exit-0 \
        --color="bg+:-1,prompt:4,border:#5a4799,hl:4,hl+:4,fg+:6" \
        --tac \
        --pointer=" " \
        --exact \
        --prompt="Branch> ")

if [[ -z "${branch_name}" ]]; then
    exit 1
fi

git switch "${branch_name}"


