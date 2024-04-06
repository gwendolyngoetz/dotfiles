#!/bin/bash

renovate_branches="$(gh pr list \
     --author "renovate[bot]" \
     --draft=false \
     --json isDraft,headRefName,mergeable,mergeStateStatus \
     --jq '.[] | select(.mergeable=="MERGEABLE")' \
     | jq -r '.headRefName' \
     | sort)"

if [[ "${renovate_branches}" == "" ]]; then
    echo "No branches to merge"
    exit 0
fi

# | fzf --multi --preview "gh pr view {} --json title,body | jq -r '.body'" --preview-window wrap \

echo "${renovate_branches}" \
| fzf --multi \
| while read -r branch_name; do
    gh pr merge "${branch_name}" --auto --squash
    gh pr review --approve "${branch_name}"
done


