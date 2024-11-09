#!/bin/bash

resourceGroup='dbfromcli'
location='eastus'

if [ $(az group exists --name $resourceGroup) = false ]; then 
    echo "creating resource group $resourceGroup "
   az group create --name $resourceGroup --location "$location" 
else
   echo "$resourceGroup already exists"
fi