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
    local result=0

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
    local result=0

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
        "Darwin") result="" ;;
        "Linux")  result="" ;;
    esac

    echo "${result}"
}

function computer::get_pwd {
    dirs +0
}

function prompt::format {
    local str="${1}"
    local textcolor="${2}"
    local fgcolor="${3}"
    local bgcolor="${4}"
    local borderstyle="${5}"

    # 0 = curved-both
    # 1 = no border
    # 2 = curved-left
    # 3 = curved-right
    
    local text="${textcolor}${bgcolor}${str}${RC2}"

    local label=""

    if [[ "${borderstyle}" -eq 0 || "${borderstyle}" -eq 2 ]]; then
        label+="${fgcolor}${LabelSeparatorOpen}${RC}"
    else
        label+="${bgcolor} ${RC}"
    fi

    label+="${text}"
    
    if [[ "${borderstyle}" -eq 0 || "${borderstyle}" -eq 3 ]]; then
        label+="${fgcolor}${LabelSeparatorClose}${RC}"
    else
        label+="${bgcolor} ${RC}"
    fi
    
    echo "${label}"
}

function prompt::display {
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
                    \#\#)branch_line=$(awk -F '\\.\\.\\.' '{print substr($1,4) }' <<< $line); break ;;
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
    LabelGitOpen="[ "
    LabelGitClose=" ]"
    LabelGitSeparator=" | "
    LabelGitSeparator="  "
    #LabelSeparator=" "
    #LabelSeparatorClose=""
    LabelSeparatorOpen=""
    LabelSeparatorClose=""


    logoBorder=1
    usernameBorder=0
    hostnameBorder=0

    if [[ ${is_remote} -eq 1 && ${is_sudo} -eq 1 ]]; then
        usernameBorder=1
        hostnameBorder=3
    elif [[ ${is_remote} -eq 1 ]]; then
        hostnameBorder=3
    elif [[ ${is_sudo} -eq 1 ]]; then
        usernameBorder=3
    else
        logoBorder=3
    fi

    pwdBorder=0
    if [[ ${is_repo} -eq 1 ]]; then
        pwdBorder=2
    fi

    LabelOS="$(prompt::format "${os_icon} " "${Black}" "${Yellow}" "${BgYellow}" ${logoBorder})"
    LabelUsername="$(prompt::format " ${username}" "${White}" "${Red}" "${BgRed}" ${usernameBorder})"
    LabelHostname="$(prompt::format " ${hostname}" "${Black}" "${LightGreen}" "${BgLightGreen}" ${hostnameBorder})"
    LabelPwd="  $(prompt::format "ﱮ ${current_dir}" "${Black}" "${LightBlue}" "${BgLightBlue}" ${pwdBorder})"

    LabelBranch="${Purple} ${branch_line}${RC}"


    #
    Output=""

    Output+="${LabelOS}"

    if [[ ${is_sudo} -eq 1 ]]; then
        Output+="${LabelUsername}"
    fi

    if [[ ${is_remote} -eq 1 ]]; then
        Output+="${LabelHostname}"
    fi

    Output+="${LabelPwd}"


    if [[ ${is_repo} -eq 1 ]]; then

        LabelChanges=""
        if [[ ${clean} -eq 0 ]]; then
            LabelChanges="  "
        fi

        LabelBranch="$(prompt::format " ${branch_line}${LabelChanges}" "${Black}" "${LightPurple}" "${BgLightPurple}" 3)"

        Output+="${LabelBranch}"
    fi

    printf "${Output}\n$ \n"
}

function prompt::set_prompt {
    PS1=$(prompt::display)
}


source "$(dirname ${BASH_SOURCE})/lib/colors.sh"
