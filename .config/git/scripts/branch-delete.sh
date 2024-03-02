#!/bin/bash


branch_name=$(git branch \
    | sed 's/\ \+/ /g' \
    | cut -d' ' -f2 \
    | grep -v "main" \
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

branch_args=(-d)

if [[ "${1}" == "-f" ]]; then
    branch_args=(-D) 
fi

git branch "${branch_args[@]}" "${branch_name}"


