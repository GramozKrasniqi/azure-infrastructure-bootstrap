#!/bin/bash
# Script to create an storage for tfstate
# command line arguments 

. ./azlogin.sh

az group create -l $location -n $st_resource_group_name

az storage account create \
    --name $st_storage_account_name \
    --resource-group $st_resource_group_name \
    --location $location \
    --sku Standard_LRS \
    --access-tier Hot \
    --kind BlobStorage

st_key=$(az storage account keys list -g $st_resource_group_name -n $st_storage_account_name --query [0].value -o tsv)

az storage container create \
    --name $st_container_name \
    --account-key $st_key \
    --account-name $st_storage_account_name

export st_key