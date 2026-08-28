#!/bin/bash 


# Set in your .profile file
#AIRNOW_API_ZIPCODE='' # five digit zipcode
#AIRNOW_API_KEY=''     # api key from registering 


AIRNOW_API_URL="http://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=${AIRNOW_API_ZIPCODE}&API_DATE&API_KEY=${AIRNOW_API_KEY}" 

AIRNOW_API_RESPONSE=$(curl --silent --location --request GET "${AIRNOW_API_URL}")


OUTPUT=$(echo "${AIRNOW_API_RESPONSE}" | jq -r '.[]
| select(.ParameterName=="PM2.5")
| ((.AQI|tostring) + " " + .Category.Name)
| .[0:5]' 2>&1)


if [[ "${OUTPUT:0:11}" = "parse error" ]]; then
    echo "??"
else
    echo "${OUTPUT}" | awk -F" " '{ print $1 "-" substr($2,1,1) }'
fi



