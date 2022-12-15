#!/bin/bash

# get all regions
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
do
    echo "current region is ${region}"
    for instance_id in $(aws ec2 describe-instances --region ${region} --filters "Name=tag:Env,Values=test" --query "Reservations[].Instances[].InstanceId" --output text)
    do
        echo "stopping instance with instance id ${instance_id}"
        aws ec2 stop-instances --instance-ids ${instance_id} --region ${region}
        #aws ec2 terminate-instances --instance-ids ${instance_id} --region ${region}
        #aws ec2 start-instances --instance-ids ${instance_id} --region ${region}
    done
done