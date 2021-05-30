#!/bin/bash

# Lets get all the security group names
groupnames=$(aws ec2 describe-security-groups --query "SecurityGroups[*].GroupName")

for group in ${groupnames}
do
    echo "${group}"
done

# Lets get all the security group ids
groupids=$(aws ec2 describe-security-groups --query "SecurityGroups[*].GroupId")

# find the ip address of the instances 
publicips=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --text)

# find the ipaddress of specific instance
publicip=$(aws ec2 describe-instances --instance-ids i-0d97976949ae63a82 --query "Reservations[*].Instances[*].PublicIpAddress" --text)

# Write a aws cli query to print the key pair names
aws ec2 describe-key-pairs --query "KeyPairs[*].KeyName" --output text
