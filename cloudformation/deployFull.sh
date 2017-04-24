#!/bin/bash

# Shellscript to deploy all stacks consecutively

if [[ $# -ne 1 ]]; then
  echo "You need to supply an argument for target"
  exit 1
fi

target=$1

# Need uppercase first letter for stack name
upperTarget="$(tr '[:lower:]' '[:upper:]' <<< ${target:0:1})${target:1}"

# Build stack names
networkingStackName="${upperTarget}-networking"
webStackName="${upperTarget}-web"

# Create Networking stack
aws cloudformation create-stack \
 --stack-name $networkingStackName \
 --template-body file://templates/networking.json \
 --parameters file://parameters/$target/$target-networking.json

# Wait for Networking stack creation
aws cloudformation wait stack-create-complete --stack-name $networkingStackName

echo
echo "Networking stack complete!!!"
echo

# Create Web Stack
aws cloudformation create-stack \
 --stack-name $webStackName \
 --template-body file://templates/web.json \
 --parameters file://parameters/$target/$target-web.json \
 --capabilities "CAPABILITY_NAMED_IAM"

 # Wait for Web stack creation
aws cloudformation wait stack-create-complete --stack-name $webStackName

echo
echo "Web stack complete!!!"
echo
echo
echo "Full stack creation complete, exiting!"
echo
