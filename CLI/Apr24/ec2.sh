#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <action> <tagName> <tagValue>"
    echo "action: start|stop|terminate"
    exit 1
else
    action=$1
    tagName=$2
    tagValue=$3
fi


# get all active regions for my account

regions=$(aws ec2 describe-regions \
        --query "Regions[].RegionName" \
        --output text)

# loop through all regions
for region in $regions; do
    echo "Checking region ${region}"
    # get all ec2 instances with tag Env = Dev
    instance_ids=$(aws ec2 describe-instances \
        --filters "Name=tag:${tagName},Values=${tagValue}" \
        --query "Reservations[0].Instances[].InstanceId" \
        --output text\
        --region $region)
    
    if [[  $instance_ids != "None" ]]; then
        echo "Action ${action} will be performed on ${instance_ids}"
        if [[ $action == "start" ]]; then
            # start all the instances
            aws ec2 start-instances \
                --instance-ids $instance_ids \
                --region $region > /dev/null
        elif [[ $action == "stop" ]]; then
            # stop all the instances
            aws ec2 stop-instances \
                --instance-ids $instance_ids \
                --region $region > /dev/null
        elif [[ $action == "terminate" ]]; then
            # terminate all the instances
            aws ec2 terminate-instances \
                --instance-ids $instance_ids \
                --region $region > /dev/null
        else
            echo "Invalid action ${action}"
            echo "doing nothing"  
        fi
        
    else
        echo "No instances found with tag ${tagName} = ${tagValue}"
    fi
done


