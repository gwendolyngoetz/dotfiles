#!/bin/bash

SVG_RESPONSE=$(curl -s https://github.com/seattle-civiform/civiform-deploy/actions/workflows/deploy-staging.yml/badge.svg?branch=main)
FAILING_COUNT=$(echo $SVG_RESPONSE | grep --ignore-case -o failing | wc -l)

if [[ $FAILING_COUNT > 0 ]]; then
  echo " CiviStage-Fail "
else
  echo ""
fi
