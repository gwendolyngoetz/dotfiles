#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

is_draft=false
label=''

while [[ "$#" -gt 0 ]]; do
    case "${1}" in
        (--draft) is_draft=true ;;
        (--label) label="${2}" ; shift ;;
    esac
    shift
done

gh_args=()
gh_args+=("--assignee @me")

# Set labels
if [[ -n "${label}" ]]; then
    gh_args+=("--label ${label}")
fi

# repository=$(git remote -v | head --lines 1 | cut -d: -f2 | cut -d. -f1)
# if [[ "${repository}" == "civiform/civiform" ]]; then
#     echo "d"
# elif [[ "${repository}" == "gwendolyngoetz/sampleproj" ]]; then
#     IFS=',' read -r -a labels <<< "${label}"
#     for element in "${labels[@]}"
#     do
#         echo "$element"
#     done
# fi

# Set template
if [[ -f ./.github/pull_request_template.md ]]; then
    gh_args+=("--template pull_request_template.md")
else
    gh_args+=("--fill")
fi

# Set Draft
if [[ "${is_draft}" == true ]]; then
    gh_args+=("--draft")
fi


#echo "gh pr create "${gh_args[@]}""
gh pr create ${gh_args[@]}

popd > /dev/null || exit
