# vim: ft=bash
#!/bin/bash

function _workon_completions() {
  COMPREPLY=($(compgen -W "$(find $HOME/src -name .git -type d -prune -exec dirname {} \; | sort | awk -F"/" '{print $NF}')" -- "${COMP_WORDS[1]}"))
}


complete -F _workon_completions workon
