#!/bin/bash

function workon {
  repo_name=$1

  if [[ -z $repo_name ]]; then
    echo "Missing repo parameter" >&2
    return
  fi

  for dir in $(find $HOME/src -name .git -type d -prune); do
    dir=$(dirname $dir)
    if [[ $dir == *$repo_name ]]; then
      echo $dir
      cd $dir
      return
    fi
  done
}
