az extension add --name azure-devops

az devops login 

az devops project create 
--name Tregu \
--detect true \
--source-control git \
--visibility private \