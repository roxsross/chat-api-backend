#!/bin/bash
# export values from environment.json file
# set -x

if [ -z $ENVIRONMENT_FILE ]; then
  ENVIRONMENT_FILE="config.json"
fi

if [ -z $GIT_BRANCH ]; then
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
else 
  BRANCH_NAME=$GIT_BRANCH
fi

echo "Reading CONFIG: $BRANCH_NAME FROM $ENVIRONMENT_FILE"

if [ ! -f "$ENVIRONMENT_FILE" ]; then
        echo -e "\n\e[1;31m The File $ENVIRONMENT_FILE not exists"
        echo -e "\e[0m \n\n\n"
        exit 1
fi
jq -r ".environments.\"$BRANCH_NAME\"" $ENVIRONMENT_FILE

$(jq -r ".environments.\"$BRANCH_NAME\"" $ENVIRONMENT_FILE | jq -r 'keys[] as $k| "export \($k)=\(.[$k])"')