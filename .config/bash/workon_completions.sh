# vim: ft=bash
#!/bin/bash

function _workon_completions() {
  if command -v fd &> /dev/null; then
    COMPREPLY=($(compgen -W "$(fd -H --type directory --prune ^.git$ $HOME/src --exec-batch dirname | awk -F"/" '{print $NF}' | sort)" -- "${COMP_WORDS[1]}"))
  else
    COMPREPLY=($(compgen -W "$(find $HOME/src -name .git -type d -prune -exec dirname {} \; | awk -F"/" '{print $NF}' | sort)" -- "${COMP_WORDS[1]}"))
  fi
}


if ! command -v fd &> /dev/null; then
  echo "fd command not found. workon completions falling back to slower find method"
fi

complete -F _workon_completions workon
