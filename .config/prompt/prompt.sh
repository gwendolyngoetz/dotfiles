#!/bin/bash

function git::is_repo {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "1"
    else
        echo "0"
    fi
}

function git::get_repo_name {
    local repo_git_dir="$(git rev-parse --absolute-git-dir)"
    local repo_dir="$(dirname ${repo_git_dir})"
    local repo_name="$(basename ${repo_dir})"

    echo "${repo_name}"
}

function git::get_repo_relative_path {
    local repo_git_dir="$(git rev-parse --absolute-git-dir)"
    local repo_dir="$(dirname ${repo_git_dir})"
    local pwd="$(pwd)"
    pwd="${pwd#${repo_dir}}"

    if [[ -z "${pwd}" ]]; then
        pwd="/"
    fi

    echo "${pwd}"
}

function git::get_repo_pretty_path {
    local repo_name="$(git::get_repo_name)"
    local repo_rel_path="$(git::get_repo_relative_path)"

    echo "${repo_name}: ${repo_rel_path}"
}

function git::get_status_count {
    local is_repo=${1}
    local result=0

    if [[ ${is_repo} -eq 1 ]]; then
        result="$(git status --porcelain --branch --untracked-files=normal --ignore-submodules=all --show-stash --no-column 2>/dev/null | wc -l | tr -d ' ')"
    fi
    
    echo "${result}"
}

function git::get_stash_count {
    local is_repo=${1}
    local result=0

    if [[ ${is_repo} -eq 1 ]]; then
        result=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    fi

    echo "${result}"
}

function git::is_clean {
    local is_repo=${1}
    local result=0

    if [[ ${is_repo} -eq 1 ]]; then
        status_count=$(git::get_status_count ${is_repo})
        stash_count=$(git::get_stash_count ${is_repo})

        if [[ $(( ${status_count} + ${stash_count} )) -le 1 ]]; then
            result=1
        fi
    fi

    echo "${result}"
}

function git::get_branch_name {
    local is_repo=${1}
    local result=""

    if [[ ${is_repo} -eq 1 ]]; then
        result=$(git branch --show-current)

        if [[ -z "${result}" ]]; then
            result=":$(git rev-parse --short HEAD)"
        fi
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

    distro=""

    case "$(uname -s)" in
        "Darwin")    distro="osx" ;;
        "GNU/Linux") distro="linux" ;;
    esac
    distro="osx"

    if [[ "${distro}" -eq "linux" ]]; then
        if [[ -f "/etc/os-release" ]]; then
            distro="$(egrep '^ID=' /etc/os-release | cut -d"=" -f2)"
        fi

        if [[ -z "${distro}" ]]; then
            distro="linux"
        fi
    fi

    case "${distro}" in
        "osx")     result="" ;;
        "ubuntu")  result="" ;;
        "debian")  result="" ;;
        "fedora")  result="" ;;
        "arch")    result="" ;;
        "manjaro") result="" ;;
        "nixos")   result="" ;;
        "linux")   result="" ;;
        "*")       result="" ;;
    esac

    echo "${result}"
}

function computer::get_pwd {
    dirs +0
}

function computer::is_narrow_window {
    local result=0

    if [[ "$(tput cols)" -le 64 ]]; then
        result=1
    fi

    echo "${result}"
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
    #label+="\e[1;38;2;${textColor}m"    # fg text
    label+="\e[38;2;${textColor}m"    # fg text
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
    branch_name="$(git::get_branch_name ${is_repo})"
    is_clean=$(git::is_clean ${is_repo})
    is_remote=$(ssh::is_remote)
    is_sudo=$(sudo::is_sudo)
    is_narrow_window=$(computer::is_narrow_window)
    username=$(computer::get_username)
    hostname="$(computer::get_hostname ${is_remote})"
    current_dir=$(computer::get_pwd)
    os_icon=$(computer::get_os_icon)

    # Format Labels
    LabelSeparatorClose=""

  
    ColorFontBlack="0;0;0"
    ColorFontWhite="224;224;224"
    ColorOS="149;154;85"
    ColorUsername="225;85;85"
    ColorHostname="33;170;18"
    ColorPwd="90;85;154"
    ColorBranch="98;114;164"

    ColorOSClose=""
    ColorUsernameClose=""
    ColorHostnameClose=""

    if [[ ${is_remote} -eq 1 && ${is_sudo} -eq 1 ]]; then
        ColorOSClose="${ColorUsername}"
        ColorUsernameClose="${ColorHostname}"
        ColorHostnameClose="${ColorPwd}" 
    elif [[ ${is_sudo} -eq 1 ]]; then
        ColorOSClose="${ColorUsername}"
        ColorUsernameClose="${ColorPwd}"
    elif [[ ${is_remote} -eq 1 ]]; then
        ColorOSClose="${ColorHostname}"
        ColorHostnameClose="${ColorPwd}" 
    else
        ColorOSClose="${ColorPwd}"
    fi

    LabelChanges=""
    if [[ ${is_clean} -eq 0 ]]; then
        LabelChanges=" "
    fi

    ColorPwdClose=""
    LabelBranch=""
    if [[ ${is_repo} -eq 1 ]]; then
        ColorPwdClose="${ColorBranch}"

        if [[ "${is_narrow_window}" -eq 1 ]]; then
            branch_name=""
        fi

        LabelBranch="$(prompt::format     " ${branch_name}${LabelChanges}"   "${ColorFontBlack}"   "${ColorBranch}"     ""     "${LabelSeparatorClose}")"
    fi

    #                                 Text                 TextColor        BgColor              NextBgColor               Separator
    LabelOS="$(prompt::format         "${os_icon}"         "${ColorFontBlack}"   "${ColorOS}"         "${ColorOSClose}"         "${LabelSeparatorClose}")"
    LabelUsername="$(prompt::format   ""                  "${ColorFontBlack}"   "${ColorUsername}"   "${ColorUsernameClose}"   "${LabelSeparatorClose}")"
    LabelHostname="$(prompt::format   ""                  "${ColorFontBlack}"   "${ColorHostname}"   "${ColorHostnameClose}"   "${LabelSeparatorClose}")"
   
    LabelPwd=""
    if [[ ${is_repo} -eq 1 ]]; then
        repo_pretty_path="$(git::get_repo_pretty_path)"
        LabelPwd="$(prompt::format        " ${repo_pretty_path}"   "${ColorFontWhite}"   "${ColorPwd}"        "${ColorPwdClose}"        "${LabelSeparatorClose}")"
    else
        LabelPwd="$(prompt::format        "ﱮ ${current_dir}"   "${ColorFontWhite}"   "${ColorPwd}"        "${ColorPwdClose}"        "${LabelSeparatorClose}")"
    fi



    # Format output
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
        Output+="${LabelBranch}"
    fi

    printf "${Output}\n_ \n"
}

function prompt::set_prompt {
    PS1=$(prompt::display)
}


