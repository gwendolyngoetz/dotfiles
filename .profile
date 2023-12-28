# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Don't rerun if under tmux
if [ -n "$TMUX" ]; then
    return
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Java-11
if [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ] ; then
    export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
    export PATH="$JAVA_HOME/bin":$PATH
fi

# Coursier
if [ -d "$HOME/.local/share/coursier/bin" ] ; then
    export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi

# Dotnet
if [ -d "$HOME/.dotnet" ] ; then
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"
fi

# Go
if [ -f "$HOME/.golang/bin/go" ]; then
    export GOPATH="$HOME/.golang" 
    export PATH="$GOPATH/bin:$PATH"
fi

# Node
if [ -d "$HOME/.local/share/nvm" ]; then
  export NVM_DIR="$HOME/.local/share/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Rust
if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# Ocaml / opam configuration
if [[ -f "$HOME/.opam/opam-init/init.sh" ]]; then
    . "$HOME/.opam/opam-init/init.sh"
fi

# environment variables not to check in to source control
if [ -f "$HOME/.private-env" ] ; then
    source "$HOME/.private-env"
else
    echo "$HOME/.private-env file not found" 1>&2
fi

export HISTFILE="$HOME/.config/bash/bash_history"
export HISTCONTROL=ignoreboth

