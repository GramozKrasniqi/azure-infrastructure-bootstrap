echo 'Login to Azure'

subscriptionId = $(az account show --query id -o tsv)
rgName = 'acr-rg-westeurope'
location = 'westeurope'

az group create -n $rgName -l $location

az acr create --name acrwesteurope \
--resource-group $rgName \
--sku Basic \
--location $location
--subscription $subscriptionId