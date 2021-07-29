#!/bin/bash

# Print the current temperature
OUTPUT=$(curl -s wttr.in/seattle?format=j1 | jq -r '.current_condition[0].FeelsLikeF')

echo $OUTPUT°F
