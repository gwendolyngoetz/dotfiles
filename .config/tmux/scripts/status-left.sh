#!/bin/bash

readonly session_name="${1}"
readonly color_fg="#8375b2"
echo "#[fg=${color_fg},bold]${session_name}"



#readonly color_text="#000000"
#readonly color_bar="#282936"
#readonly color_repo="#5a559a"
#readonly color_branch="#6272a4"
#readonly color_os="#959a55"
#
#format=""
#format+="{{if .OsIcon}}#[fg=${color_text} bg=${color_os}] {{.OsIcon}}  {{end}}"
#format+="#[bg=${color_repo}] {{if .RepositoryName}}{{.RepositoryName}}{{else}}${session_name} #[fg=${color_repo} bg=${color_bar}]{{end}}"
#format+="{{if .BranchName}}#[fg=${color_text} bg=${color_branch}] {{.BranchName}}#[fg=${color_branch} bg=${color_bar}]{{end}}"
#
#prompt tmux --format "${format}"
#
##tmux refresh-client -S

