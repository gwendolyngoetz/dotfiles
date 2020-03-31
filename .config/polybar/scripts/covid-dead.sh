#!/bin/bash

TODAY=$(date -d yesterday +%Y-%m-%d)
JSON=$(curl -s https://covidapi.info/api/v1/country/USA/$TODAY)

echo $JSON | jq -r ".result.\"$TODAY\".deaths" | numfmt --grouping 
