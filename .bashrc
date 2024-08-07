
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
HISTIGNORE='ls:ll:cd:pwd:bg:fg:clear'

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

if [[ -f "$HOME/.config/aliases-osx" && "$(uname -s)" == "Darwin" ]]; then
    source $HOME/.config/aliases-osx
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
export DOCKER_HOST=unix:///run/user/1000/docker.sock

# XDG Data Directories
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# GTK
export GTK_THEME=Dracula:dark

# Libvirt/KVM
export LIBVIRT_DEFAULT_URI="qemu:///system"

# Civiform
export USE_LOCAL_CIVIFORM=1

# Ansible
#export ANSIBLE_CONFIG=~/.config/ansible/ansible.cfg

if [ -f "$HOME/.cargo/env" ]; then
    source $HOME/.cargo/env
fi

if [ -f "$HOME/.config/functions" ]; then
    source $HOME/.config/functions
fi

# Prompt
if [ -f "$HOME/.local/bin/prompt" ]; then
    PROMPT_COMMAND=set_prompt
fi

# Configure less for man page coloring
if [ -f "$HOME/.config/bash/less.conf" ]; then
    source $HOME/.config/bash/less.conf
fi

# Completion for workon function
if [ -f "$HOME/.config/bash/workon_completions.sh" ]; then
    source $HOME/.config/bash/workon_completions.sh
fi

# Java sdkman source
if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    source $HOME/.sdkman/bin/sdkman-init.sh
fi

if [ -f "/usr/bin/terraform" ]; then
    complete -C /usr/bin/terraform terraform
fi

if [ -d "$HOME/.config/nvm" ]; then
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
#     TMUX_SESSION="remote"
#     tmux attach-session -t $TMUX_SESSION || tmux new-session -s $TMUX_SESSION
# fi

