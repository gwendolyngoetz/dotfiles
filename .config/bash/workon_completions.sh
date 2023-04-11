#!/bin/bash

function _workon_completions() {
    COMPREPLY=($(compgen -W "$(fd -H --type directory --prune ^.git$ $HOME/src --exec-batch dirname | awk -F"/" '{print $NF}' | sort)" -- "${COMP_WORDS[1]}"))
}


if ! command -v fd &> /dev/null; then
  echo "fd command not found"
  return
fi

complete -F _workon_completions workon
