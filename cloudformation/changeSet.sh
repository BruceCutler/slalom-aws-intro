#!/bin/bash

## TODO : Create Script that can create/execute change sets on a particular stack
if [[ $# -ne 2 ]]; then
  echo "You need to supply arguments for target and stack"
  exit 1
fi

target=$1
stack=$2

if [[ $stack == "web" ]]; then
  capabilities='--capabilities CAPABILITY_NAMED_IAM'
fi

# Need uppercase first letter for stack name
upperTarget="$(tr '[:lower:]' '[:upper:]' <<< ${target:0:1})${target:1}"
stackName="${upperTarget}-$stack"

aws cloudformation create-change-set \
 --stack-name $stackName \
 --template-body file://templates/$stack.json \
 --parameters file://parameters/$target/$target-$stack.json \
 --change-set-name $stack-change $capabilities
