#!/bin/bash

# Print the current temperature

curl -s wttr.in/seattle?format=%t | awk -F + '{print $1$2}'
