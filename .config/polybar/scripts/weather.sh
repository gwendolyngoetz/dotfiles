#!/bin/bash

# Print the current temperature
#OUTPUT=$(curl -s wttr.in/seattle?format=j1 | jq -r '.current_condition[0].temp_F')
#echo $OUTPUT°F

OUTPUT=$(curl -s wttr.in/seattle?format="%t")
echo $OUTPUT | sed 's/+//g'
