#!/bin/bash

subscriptionId = $(az account show --query id -o tsv)
spName = "Automation"

az ad sp create-for-rbac \
--name $spName \
--role "Contributor" \ 
--scopes "/subscriptions/$subscriptionId"

echo "Subscription id is: $subscriptionId"
echo "Service principal app id is: $(az ad sp list --display-name $spName --query "[].appId" -o tsv)"