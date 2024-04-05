#!/bin/bash

# usage vnet.sh <group-name> <location> <action>

if [ $# -ne 3 ]; then
    echo "wrong arguments passed"
    echo "usage: vnet.sh <group-name> <location> <action>"
    exit 1
fi
GROUP_NAME=$1
LOCATION=$2
ACTION=$3

if [ $ACTION != "create" ] && [ $ACTION != "delete" ]; then
    echo "as of now only create and delete actions are supported"
    exit 1
fi

if [ $ACTION == "create" ]; then

    if [ $(az group exists --name $GROUP_NAME) = true ]; then 
        echo "group already exists"
    else
        az group create \
            --location $LOCATION \
            --name $GROUP_NAME
        echo "group created"
    fi

    az network vnet create \
        --name 'learning' \
        --resource-group $GROUP_NAME \
        --address-prefixes '192.168.0.0/16' \
        --location $LOCATION \
        --tags "CreatedBy=cli"
    echo "vnet created"

    az network vnet subnet create \
        --name "web-1" \
        --resource-group $GROUP_NAME \
        --vnet-name 'learning' \
        --address-prefixes "192.168.0.0/24" 
    echo "web-1 subnet created"

    az network vnet subnet create \
        --name "web-2" \
        --resource-group $GROUP_NAME \
        --vnet-name 'learning' \
        --address-prefixes "192.168.1.0/24"
    echo "web-2 subnet created"


    az network vnet subnet create \
        --name "db-1" \
        --resource-group $GROUP_NAME \
        --vnet-name 'learning' \
        --address-prefixes "192.168.2.0/24" 
    echo "db-1 subnet created"

    az network vnet subnet create \
        --name "db-2" \
        --resource-group $GROUP_NAME \
        --vnet-name 'learning' \
        --address-prefixes "192.168.3.0/24"
    echo "db-2 subnet created"
elif [ $ACTION == "delete" ]; then
    az group delete --name $GROUP_NAME --yes
fi