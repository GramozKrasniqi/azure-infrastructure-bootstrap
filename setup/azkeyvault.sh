echo 'Login to Azure'

rgName = 'kvrg-westeurope'
location = 'westeurope'

az group create -n $rgName -l $location
az keyvault create -n kv-kilino-westeurope -g $rgName -l $location