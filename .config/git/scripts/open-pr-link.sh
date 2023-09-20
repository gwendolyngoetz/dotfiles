#!/bin/bash

origin="$(git ls-remote --get-url origin | sed -n "s/^.*github.com\/*:*\s*\(\S*\).git.*$/\1/p")"
branch_name="$(git rev-parse --abbrev-ref HEAD)"
url="$(curl --silent "https://api.github.com/repos/${origin}/pulls?page_page=1&head=civiform:${branch_name}" | jq -r .[0].html_url)"

xdg-open "${url}"
