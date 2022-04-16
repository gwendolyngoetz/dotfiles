# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE= HISTFILESIZE= # Infinite history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case "$TERM" in
    xterm-color|*-256color)
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';;
    *)
        PS1='\u@\h:\w\$ ';;
esac


# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi


# This keeps vim from freezing when pressing ctrl-s. Without you have to 
# press ctrl-q to resume
stty -ixon

if [ -f "$HOME/.config/aliases" ]; then
    source $HOME/.config/aliases
fi

# Disable less history
export LESSHISTFILE=-

# Opt-out of dotnet telemtry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# AWS
export AWS_CONFIG_FILE=~/.config/aws/config
export AWS_DATA_PATH=~/.config/aws/models
export AWS_SHARED_CREDENTIALS_FILE=~/.config/aws/credentials

# Docker
if [ "$(uname -s)" == "Linux" ]; then
    export DOCKER_HOST=unix:///run/user/1000/docker.sock
fi

# Ansible
#export ANSIBLE_CONFIG=~/.config/ansible/ansible.cfg

if [ -f "$HOME/.cargo/env" ]; then
    source $HOME/.cargo/env
fi

if [ -f "$HOME/.config/tools/functions.sh" ]; then
    source $HOME/.config/tools/functions.sh
fi

# Git Prompt
if [ -f "$HOME/.config/gitprompt/config" ]; then
    source $HOME/.config/gitprompt/config
fi

