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
    local text="${1}"
    local textColor="${2}"
    local bgColor="${3}"
    local nextBgColor="${4}"
    local labelSeparatorClose="${5}"

    # Reset Color
    RC='\033[0m'
    RC2="${RC}${RC}"


    local label=""
    label+="\e[48;2;${bgColor}m"        # bg text
    label+="\e[1;38;2;${textColor}m"    # fg text
    label+=" ${text} "                  # text
    label+="${RC2}"                     # reset text
    label+="\e[48;2;${nextBgColor}m"    # bg separator
    label+="\e[1;38;2;${bgColor}m"      # fg separator
    label+="${labelSeparatorClose}"     # separator
    label+="${RC2}"                     # reset separator

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
    
    #LabelSeparatorClose=""
    LabelSeparatorOpen=""
    LabelSeparatorClose=""



    #   if [[ ${is_remote} -eq 1 && ${is_sudo} -eq 1 ]]; then
    #   elif [[ ${is_remote} -eq 1 ]]; then
    #   elif [[ ${is_sudo} -eq 1 ]]; then
    #   else
    #   fi

  
    ColorFont="0;0;0"
    ColorOS="225;192;120" # drac red
    ColorOS="134;153;71" # drac red
    #ColorOS="241;250;140" # drac yellow
    #ColorOS="255;184;108" # drac orange
    ColorUsername="225;85;85"
    ColorHostname="33;170;18"
    ColorPwd="90;71;153"
    #ColorPwd="189;147;249" # drac purple
    ColorBranch="98;114;164" #drac comment

    #                                 Text                 TextColor        BgColor              NextBgColor          Separator
    #LabelOS="$(prompt::format         "${os_icon}"         "${ColorFont}"   "${ColorOS}"         "${ColorUsername}"   "${LabelSeparatorClose}")"
    LabelOS="$(prompt::format         "${os_icon}"         "${ColorFont}"   "${ColorOS}"         "${ColorPwd}"        "${LabelSeparatorClose}")"
    LabelUsername="$(prompt::format   " ${username}"      "${ColorFont}"   "${ColorUsername}"   "${ColorHostname}"   "${LabelSeparatorClose}")"
    LabelHostname="$(prompt::format   " ${hostname}"      "${ColorFont}"   "${ColorHostname}"   "${ColorPwd}"        "${LabelSeparatorClose}")"
    LabelPwd="$(prompt::format        "ﱮ ${current_dir}"   "${ColorFont}"   "${ColorPwd}"        "${ColorBranch}"     "${LabelSeparatorClose}")"



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
            LabelChanges=" "
        fi

        LabelBranch="$(prompt::format     " ${branch_line}${LabelChanges}"   "${ColorFont}"   "${ColorBranch}"     ""     "${LabelSeparatorClose}")"

        Output+="${LabelBranch}"
    fi

    printf "${Output}\n \n"
    #printf "${Output}\n$ \n"
}

function prompt::set_prompt {
    PS1=$(prompt::display)
}


