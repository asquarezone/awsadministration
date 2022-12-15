#!/bin/bash
region=$1
vpc_id=$2

# create a security group
gid=$(aws ec2 create-security-group \
    --description "open all ports" \
    --group-name "openall" \
    --vpc-id "$vpc_id" \
    --query "GroupId" --region $region --output text)

# create a security group inbound/ingress rule 
aws ec2 authorize-security-group-ingress \
    --group-id $gid \
    --protocol tcp \
    --port "0-65535" \
    --cidr "0.0.0.0/0" \
    --region "$region"


# add rules