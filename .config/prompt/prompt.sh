#!/bin/bash

SEPARATOR_ICON=""
COLOR_FONT_BLACK="0;0;0"
COLOR_FONT_WHITE="224;224;224"
COLOR_OS="149;154;85"
COLOR_USERNAME="225;85;85"
COLOR_HOSTNAME="33;170;18"
COLOR_PWD="90;85;154"
COLOR_BRANCH="98;114;164"

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
    local text_color="${2}"
    local bg_color="${3}"
    local next_bg_color="${4}"
    local separator_icon="${5}"

    # Reset Color
    reset_color='\033[0m'
    reset_color_2="${reset_color}${reset_color}"


    local label=""
    label+="\e[48;2;${bg_color}m"        # bg text
    label+="\e[38;2;${text_color}m"      # fg text
    label+=" ${text} "                   # text
    label+="${reset_color_2}"            # reset text
    label+="\e[48;2;${next_bg_color}m"   # bg separator
    label+="\e[1;38;2;${bg_color}m"      # fg separator
    label+="${separator_icon}"           # separator
    label+="${reset_color_2}"            # reset separator

    echo "${label}"
}

function prompt::display {
    #
    is_repo=$(git::is_repo)
    branch_name="$(git::get_branch_name ${is_repo})"
    is_clean=$(git::is_clean ${is_repo})
    is_remote=1 #$(ssh::is_remote)
    is_sudo=1 #$(sudo::is_sudo)
    is_narrow_window=$(computer::is_narrow_window)
    username=$(computer::get_username)
    hostname="$(computer::get_hostname ${is_remote})"
    current_dir=$(computer::get_pwd)
    os_icon=$(computer::get_os_icon)

    # Format Labels
    color_os_close=""
    color_username_close=""
    color_hostname_close=""

    if [[ ${is_remote} -eq 1 && ${is_sudo} -eq 1 ]]; then
        color_os_close="${COLOR_USERNAME}"
        color_username_close="${COLOR_HOSTNAME}"
        color_hostname_close="${COLOR_PWD}" 
    elif [[ ${is_sudo} -eq 1 ]]; then
        color_os_close="${COLOR_USERNAME}"
        color_username_close="${COLOR_PWD}"
    elif [[ ${is_remote} -eq 1 ]]; then
        color_os_close="${COLOR_HOSTNAME}"
        color_hostname_close="${COLOR_PWD}" 
    else
        color_os_close="${COLOR_PWD}"
    fi

    label_changes=""
    if [[ ${is_clean} -eq 0 ]]; then
        label_changes=" "
    fi

    color_pwd_close=""
    label_branch=""
    if [[ ${is_repo} -eq 1 ]]; then
        color_pwd_close="${COLOR_BRANCH}"

        if [[ "${is_narrow_window}" -eq 1 ]]; then
            branch_name=""
        fi

        label_branch="$(prompt::format     " ${branch_name}${label_changes}"   "${COLOR_FONT_BLACK}"   "${COLOR_BRANCH}"     ""     "${SEPARATOR_ICON}")"
    fi

    #                                 Text                 TextColor               BgColor               NextBgColor               Separator
    label_os="$(prompt::format         "${os_icon}"         "${COLOR_FONT_BLACK}"   "${COLOR_OS}"         "${color_os_close}"         "${SEPARATOR_ICON}")"
    label_username="$(prompt::format   ""                  "${COLOR_FONT_BLACK}"   "${COLOR_USERNAME}"   "${color_username_close}"   "${SEPARATOR_ICON}")"
    label_hostname="$(prompt::format   ""                  "${COLOR_FONT_BLACK}"   "${COLOR_HOSTNAME}"   "${color_hostname_close}"   "${SEPARATOR_ICON}")"
   
    label_pwd=""
    if [[ ${is_repo} -eq 1 ]]; then
        repo_pretty_path="$(git::get_repo_pretty_path)"
        label_pwd="$(prompt::format   " ${repo_pretty_path}"   "${COLOR_FONT_WHITE}"   "${COLOR_PWD}"   "${color_pwd_close}"   "${SEPARATOR_ICON}")"
    else
        label_pwd="$(prompt::format   "ﱮ ${current_dir}"        "${COLOR_FONT_WHITE}"   "${COLOR_PWD}"   "${color_pwd_close}"   "${SEPARATOR_ICON}")"
    fi



    # Format output
    output=""
    output+="${label_os}"

    if [[ ${is_sudo} -eq 1 ]]; then
        output+="${label_username}"
    fi

    if [[ ${is_remote} -eq 1 ]]; then
        output+="${label_hostname}"
    fi

    output+="${label_pwd}"

    if [[ ${is_repo} -eq 1 ]]; then
        output+="${label_branch}"
    fi

    printf "${output}\n_ \n"
}

function prompt::set_prompt {
    PS1=$(prompt::display)
}


