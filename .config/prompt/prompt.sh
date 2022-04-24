#!/bin/bash

function git::is_repo {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "1"
    else
        echo "0"
    fi
}

function git::get_status {
    local is_repo=${1}

    if [[ ${is_repo} -eq 1 ]]; then
        git status --porcelain --branch --untracked-files=normal --ignore-submodules=all --show-stash --no-column
    else
        echo ""
    fi
}

function git::get_stash_count {
    local is_repo=${1}
    local result=0

    if [[ ${is_repo} -eq 1 ]]; then
        result=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo "${result}"
}

function git::get_short_commit_hash {
    local is_repo=${1}
    local result=""

    if [[ ${is_repo} -eq 1 ]]; then
        result=$(git rev-parse --short HEAD)
    fi

    echo "${result}"
}

function ssh::is_remote {
    local result=1

    if [[ $(who am i) =~ \([-a-zA-Z0-9\.]+\)$ ]] ; then 
        result=1
    fi

    echo "${result}"
}

#function ssh::is_remote2 {
    #p=${1:-$PPID}
    #read pid name x ppid y < <( cat /proc/$p/stat )
    ## or: read pid name ppid < <(ps -o pid= -o comm= -o ppid= -p $p) 
    #[[ "$name" =~ sshd ]] && { echo "Is SSH : $pid $name"; return 0; }
    #[ "$ppid" -le 1 ]     && { echo "Adam is $pid $name";  return 1; }
    #is_ssh $ppid
#}

function sudo::is_sudo {
    local result=1

    if [[ -n ${SUDO_USER} ]]; then
        result=1
    fi

    echo "${result}"
}

function computer::get_username {
    echo "${USER}"
}

function computer::get_hostname {
    local is_remote=${1}
    local result=""

    if [[ ${is_remote} -eq 1 ]]; then
        result=$(hostname -s)
    fi

    echo "${result}"
}

function computer::get_os_icon {
    local result=""

    case "$(uname -s)" in
        "Darwin") result="A" ;;
        "Linux")  result="L" ;;
    esac

    echo "${result}"
}

function computer::get_pwd {
    dirs +0
}

source ~/gs-colors.sh

#
is_repo=$(git::is_repo)
git_status=$(git::get_status ${is_repo})


#
branch_line=""
num_staged=0
num_changed=0
num_conflicts=0
num_untracked=0
clean=0

if [[ ${is_repo} -eq 1 ]]; then
    while IFS='' read -r line || [[ -n "${line}" ]]; do
        status="${line:0:2}"
        while [[ -n ${status} ]]; do
            case "${status}" in
                #two fixed character matches, loop finished
                \#\#)branch_line=$(awk -F '\\\.\\\.\\\.' '{print substr($1,4) }' <<< $line); break ;;
                \?\?) ((num_untracked++)); break ;;
                U?) ((num_conflicts++)); break;;
                ?U) ((num_conflicts++)); break;;
                DD) ((num_conflicts++)); break;;
                AA) ((num_conflicts++)); break;;
                #two character matches, first loop
                ?M) ((num_changed++)) ;;
                ?D) ((num_changed++)) ;;
                ?\ ) ;;
                #single character matches, second loop
                U) ((num_conflicts++)) ;;
                \ ) ;;
                *) ((num_staged++)) ;;
            esac
            status="${status:0:(${#status}-1)}"
        done
    done <<< "$git_status"

    num_stashed=$(git::get_stash_count ${is_repo})

    if (( num_changed == 0 && num_staged == 0 && num_untracked == 0 && num_stashed == 0 && num_conflicts == 0)) ; then
        clean=1
    fi

    if [[ ${branch_line} == "HEAD (no branch)" ]]; then
        branch_line=":$(git::get_short_commit_hash ${is_repo})"
    fi
fi


is_remote=$(ssh::is_remote)
is_sudo=$(sudo::is_sudo)

username=$(computer::get_username)
hostname="$(computer::get_hostname ${is_remote})"
current_dir=$(computer::get_pwd)
os_icon=$(computer::get_os_icon)

# Labels
LabelOpen="[ "
LabelClose=" ]"
LabelSeparator=" | "
LabelOS="${Black}${BgYellow} ${os_icon} ${NoColor}${NoColor}"
LabelUsername="${Black}${BgRed} ${username}${NoColor}${NoColor}"
LabelHostname="${Black}${BgLightGreen}${hostname} ${NoColor}${NoColor}"
#LabelPrefix="${Green}✔${NoColor} "
LabelPwd="${Black}${BgLightBlue} ${current_dir} ${NoColor}${NoColor}"
LabelBranch="${Purple}${branch_line}${NoColor}"
LabelStaged="${Red}●${NoColor} ${num_staged}"
LabelChanged=" ${Blue}✚${NoColor} ${num_changed}"
LabelUntracked=" ${Cyan}…${NoColor}${num_untracked}"
LabelConflicts=" ${Cyan}~${NoColor}${num_conflicts}"
LabelStashed=" ${Blue}⚑ ${NoColor}${num_stashed}"

#
LabelOutput=""

LabelOutput+="${LabelOS}"

if [[ ${is_sudo} -eq 1 ]]; then
    LabelOutput+="${LabelUsername}"
fi

if [[ ${is_sudo} -eq 1 && ${is_remote} -eq 1 ]]; then
    LabelOutput+="${Black}${BgLightGreen}@${NoColor}${NoColor}"
fi

if [[ ${is_remote} -eq 1 ]]; then
    LabelOutput+="${LabelHostname}"
fi

LabelOutput+="${LabelPwd}\n"
#LabelOutput+="${LabelPrefix}"


if [[ ${is_repo} -eq 1 ]]; then
    LabelOutput+="${LabelOpen}"
    LabelOutput+="${LabelBranch}"

    if [[ ${num_staged} -gt 0 ]]; then
        LabelOutput+="${LabelSeparator}"
    fi

    if [[ ${num_staged} -gt 0 ]]; then
        LabelOutput+="${LabelStaged}"
    fi

    if [[ ${num_changed} -gt 0 ]]; then
        LabelOutput+="${LabelChanged}"
    fi

    if [[ ${num_untracked} -gt 0 ]]; then
        LabelOutput+="${LabelUntracked}"
    fi

    if [[ ${num_conflicts} -gt 0 ]]; then
        LabelOutput+="${LabelConflicts}"
    fi

    if [[ ${num_stashed} -gt 0 ]]; then
        LabelOutput+="${LabelStashed}"
    fi

    LabelOutput+="${LabelClose}"
fi

printf "${LabelOutput}\n"



#printf "branch:     ${LabelBranch}\n"
#printf "staged:     ${LabelStaged}\n"
#printf "changed:   ${LabelChanged}\n"
#printf "conflicts:  ${num_conflicts}\n"
#printf "untracked: ${LabelUntracked}\n"
#printf "stashed:   ${LabelStashed}\n"
#printf "clean:      ${clean}\n"
#printf  "ssh:        ${is_remote}\n"

# printf "\n\e[1;41m\e[1;32m\e    \U25b0\e[0m\e[0m  dd \n\n" 
