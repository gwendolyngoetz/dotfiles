#!/bin/bash

# Print the current temperature

curl -s wttr.in/seattle?format=%t | awk -F + '{print substr($1$2,1,7)}'
