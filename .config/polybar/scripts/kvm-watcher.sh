#!/bin/bash

function get_quantity_label {
  LABEL="${1}"
  SKU="${2}"
  UNFORMATTED="${3}"
  JSON="${4}"

  RESULT=""
  ICON="%{F#555}%{F-}"

  if [[ "${SKU}" != "" ]]; then
    QUANTITY=$(echo ${JSON} | jq --arg sku "${SKU}" -r '.product.variants[] | select(.sku == $sku) | .stock.quantity' 2> /dev/null)

    if [[ "${UNFORMATTED}" == "true" ]]; then
      RESULT=" ${LABEL}/${QUANTITY}"
    else
      BGCOLOR_OPEN="%{B#005221}"
      BGCOLOR_CLOSE="%{B-}"
      if [[ "${QUANTITY}" == "0" ]]; then
        BGCOLOR_OPEN=""
        BGCOLOR_CLOSE=""
      fi
      
      RESULT="${ICON} ${BGCOLOR_OPEN} ${LABEL}%{F#888} / %{F-}${QUANTITY} ${BGCOLOR_CLOSE}"
    fi
  fi

  echo "${RESULT}"
}

function get_item_name {
  JSON="${1}"

  ITEM_NAME=$(echo ${JSON} | jq -r '.item.title' 2> /dev/null)

  if [[ "${ITEM_NAME}" == "null" ]]; then
    ITEM_NAME=""
  fi

  RESULT=$(echo "${ITEM_NAME}" | \
    sed 's/^1.4 Display Port KVM Switch - //g' | \
    sed 's/Monitor -//g' | \
    sed 's/Dual/2/g' | \
    sed 's/Triple/3/g' | \
    sed 's/Quad/4/g' | \
    sed 's/Computer/力/g' | \
    sed 's/Two/2/g' | \
    sed 's/Three/3/g' | \
    sed 's/Four/4/g' | \
    awk '{print "[ " $2 " " $1 " " $4 $3 " ]"}')

  echo "${RESULT}"
}

function get_json {
  URL="${1}"

  JSON=$(curl -s "${URL}" | \
    htmlq 'script[data-name="static-context"]' --text | \
    sed 's/Static = window.Static || {}; Static.SQUARESPACE_CONTEXT = //g' | \
    sed 's/;$//g')

  echo "${JSON}"
}

function print_unformatted {
  TITLE="${1}"
  TXT1="${2}"
  TXT2="${3}"

  NOTICE="${TITLE} "

  if [[ "${TXT1}" != "" ]]; then
    NOTICE="${NOTICE}${TXT1}  "
  fi

  if [[ "${TXT2}" != "" ]]; then
    NOTICE="${NOTICE}${TXT2}  "
  fi

  echo ${NOTICE}
}

function print_formatted {
    TITLE="${1}"
    TXT1="${2}"
    TXT2="${3}"
    NOTICE="${TXT2}"
    echo ${NOTICE}
}

function print_notice {
  URL="${1}"
  SKU_G05="${2}"
  SKU_G10="${3}"
  UNFORMATTED="${4}"

  JSON=$(get_json "${URL}")
  TITLE=$(get_item_name "${JSON}")
  TXT1=$(get_quantity_label  "5G" "${SKU_G05}" "${UNFORMATTED}" "${JSON}")
  TXT2=$(get_quantity_label "10G" "${SKU_G10}" "${UNFORMATTED}" "${JSON}")
   
  if [[ "${UNFORMATTED}" == "true" ]]; then
    NOTICE=$(print_unformatted "${TITLE}" "${TXT1}" "${TXT2}")
  else
    NOTICE=$(print_formatted "${TITLE}" "${TXT1}" "${TXT2}")
  fi

  echo "${NOTICE}"
}


if [[ "${1}" == "" ]]; then 
  print_notice "https://store.level1techs.com/products/14-kvm-switch-dual-monitor-2computer" "SQ8146548" "SQ1007387" "false"
else
  print_notice "${1}" "${2}" "${3}" "true"
fi
