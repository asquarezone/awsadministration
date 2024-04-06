#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <action> <tagName> <tagValue>"
    echo "action: start|stop|delete"
    exit 1
else
    action=$1
    tagName=$2
    tagValue=$3
fi

# get all vms based on tag name and value

vms=$(az vm list --query "[? tags.$tagName == '$tagValue' ].id" --output tsv)
echo "VMs: $vms"
# if vms are not empty, process them
for vm in $vms; do
    echo "Processing $vm"
    if [[ $action == "start" ]]; then
        echo "Starting $vm"
        az vm start --ids $vm > /dev/null
    elif [[ $action == "stop" ]]; then
        echo "Stopping $vm"
        az vm deallocate --ids "$vm" > /dev/null
    elif [[ $action == "delete" ]]; then
        echo "Deleting $vm"
        az vm delete --ids $vm > /dev/null
    else
        echo "Invalid action"
        exit 1
    fi
done

