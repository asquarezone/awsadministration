#!/bin/bash
aws autoscaling create-launch-configuration \
    --launch-configuration-name 'lcfromcli' --image-id 'ami-03d5c68bab01f3496' \
    --key-name 'ansible' --security-groups 'sg-0eb0f3fca6c9a45a8' \
    --instance-type 't2.micro' --associate-public-ip-address

aws autoscaling describe-launch-configurations --query "LaunchConfigurations[*].LaunchConfigurationName"

aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name 'asgfromcli' --launch-configuration-name 'lcfromcli' \
    --min-size 1 --max-size 5 --desired-capacity 2 \
    --availability-zones "us-west-2a" "us-west-2b" "us-west-2c"

aws autoscaling describe-auto-scaling-groups


aws autoscaling put-scaling-policy \
    --auto-scaling-group-name 'asgfromcli' --policy-name 'mytargetrackingpolicy' \
    --policy-type 'TargetTrackingScaling' \
    --target-tracking-configuration 'file://config.json'
