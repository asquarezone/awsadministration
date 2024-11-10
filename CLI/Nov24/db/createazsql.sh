#!/bin/bash

set -ex

resourceGroup='dbfromcli'
location='eastus'

if [ $(az group exists --name $resourceGroup) = false ]; then 
    echo "creating resource group $resourceGroup "
   az group create --name $resourceGroup --location "$location" 
else
   echo "$resourceGroup already exists"
fi

tag="create-and-configure-database"
server="ltsqlfromcli"
database="library"
login="ltdevops"
password="motherindia@123"
# Specify appropriate IP address values for your environment
# to limit access to the SQL Database server
startIp=0.0.0.0
endIp=0.0.0.0

echo "Using resource group $resourceGroup with login: $login, password: $password..."

echo "Creating $server in $location..."
az sql server create \
   --name $server \
   --resource-group $resourceGroup \
   --location "$location" \
   --admin-user $login \
   --admin-password $password
echo "Configuring firewall..."
az sql server firewall-rule create \
   --resource-group $resourceGroup \
   --server $server \
   -n AllowYourIp \
   --start-ip-address $startIp \
   --end-ip-address $endIp
echo "Creating $database in serverless tier"
az sql db create \
   --resource-group $resourceGroup \
   --server $server \
   --name $database \
   --sample-name AdventureWorksLT \
   --edition GeneralPurpose \
   --compute-model Serverless \
   --family Gen5 \
   --capacity 2


az group delete \
   --name $resourceGroup \
   --yes