#!/bin/bash

# get default vpc
vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault].VpcId[]' --output text)

# Create a security group

aws ec2 create-security-group --description "open 22 80 and 8080 port" --group-name 'openfortomcat' --vpc-id $vpc_id

# store security group id into some variable
sg_id=$(aws ec2 describe-security-groups --group-names "openfortomcat" --query "SecurityGroups[0].GroupId" --output text)

# openports
for port_number in 22 80 8080
do
    aws ec2 authorize-security-group-ingress --group-name "openfortomcat" --protocol tcp --port "$port_number" --cidr 0.0.0.0/0
done

# get the first subnet
subnet_id=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query "Subnets[0].SubnetId" --output text)

# Create a public key if required 
# ssh-keygen

aws ec2 import-key-pair --key-name "my-key" --public-key-material fileb://~/.ssh/id_rsa.pub

# Create an ec2 instance with the security group and key created over here
