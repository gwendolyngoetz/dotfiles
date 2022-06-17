# vim: ft=bash
#!/bin/bash

function _ssh_completions() {
  COMPREPLY=($(compgen -W "$(cat ~/.ssh/known_hosts | cut -d' ' -f1 | uniq | sort)" -- "${COMP_WORDS[1]}"))
}


complete -F _ssh_completions ssh
