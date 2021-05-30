#!/bin/bash
aws ec2 run-instances --image-id 'ami-0cf6f5c8a62fa5da6' --instance-type 't2.micro' --key-name 'cheflearning' --security-groups 'openallports'  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=fromcli1}]'

# fetchin information about the ec2 instance created by us
aws ec2 describe-instances --filters 'Name=image-id,Values=ami-0cf6f5c8a62fa5da6' --query "Reservations[*].Instances[*].PublicIpAddress" --output text

aws ec2 run-instances --image-id 'ami-03d5c68bab01f3496' --instance-type 't2.micro' --key-name 'cheflearning' --security-groups 'openallports'  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=fromcli2}]'

# fetchin information about the ec2 instance created by us
aws ec2 describe-instances --filters 'Name=tag:Name,Values=fromcli2' --query "Reservations[*].Instances[*].PublicIpAddress" --output text

# Stop the ec2 instace with tag Name: fromcli2
instaceid=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=fromcli2' --query "Reservations[0].Instances[0].InstanceId" --output text)

aws ec2 stop-instances --instance-ids ${instaceid}

# Terminate the ec2 instance with tag Name: fromcli1
aws ec2 describe-instances --filters 'Name=tag:Name,Values=fromcli1' --query "Reservations[0].Instances[0].InstanceId" --output text



