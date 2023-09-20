#!/bin/bash

origin="$(git ls-remote --get-url origin | sed -n "s/^.*github.com\/*:*\s*\(\S*\).git.*$/\1/p")"
branch_name="$(git rev-parse --abbrev-ref HEAD)"

xdg-open "https://github.com/${origin}/tree/${branch_name}"
