#!/bin/bash

tagName="Env"
tagValue="Dev"


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
        echo "Following instances will be stopped: ${instance_ids}"
        # stop all the instances
        aws ec2 stop-instances \
            --instance-ids $instance_ids \
            --region $region > /dev/null
    else
        echo "No instances found with tag ${tagName} = ${tagValue}"
    fi
done


