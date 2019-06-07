#!/bin/sh

grep -e '^[^#]*bind' ~/.config/i3/config | cut -d ' ' -f2-10
