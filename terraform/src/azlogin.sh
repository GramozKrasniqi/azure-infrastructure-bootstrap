az account clear
az login --service-principal -u $client_id -p $client_secret --tenant $tenant_id
az account set --subscription $subscription_id