#!/bin/bash

# Default will only print the branch delete command.
# Pass arg[1] with "--commit" to actually force delete branch
commit_changes="${1:-"--commit"}"

# Only look at last two weeks
from_date="$(date --date '-14 days' +'%Y-%m-%d')"

completed_branches="$(gh pr list \
    --author "@me" \
    --state "merged" \
    --json "headRefName,commits" \
    --search "updated:>=${from_date}" \
| jq -c '.[] | {"branch_name": .headRefName, "sha": .commits | last .oid }' \
| while read -r line; do
    branch_name="$(jq -c -r '.branch_name' <<< "${line}")"
    remote_sha="$(jq -c -r '.sha' <<< "${line}")"
    local_sha="$(git log --max-count=1 --pretty=tformat:'%H' "${branch_name}" 2> /dev/null)"

    if [[ "${remote_sha}" == "${local_sha}" ]]; then
        echo "${branch_name}"
    fi
done | \
sort)"

if [[ "${completed_branches}" == "" ]]; then
    echo "No applicable branches to show"
    exit 0
fi

# Not doing a single pipe so fzf populates immediately
echo "${completed_branches}" \
| fzf --multi \
| while read -r branch_name; do
    if [[ "${commit_changes}" == "--commit" ]]; then
        git branch --force --delete "${branch_name}"
    else
        echo "Dry Run: git branch --force --delete ${branch_name}"
    fi
done


