#!/bin/bash

# get the ami id
ami_id=$(aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230208" --query "Images[0].ImageId" --output text)


# get default vpc id
vpc_id=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query "Vpcs[0].VpcId" --output text)

# create security group with 22,80 ports opened
sg_id=$(aws ec2 create-security-group --group-name sshnhttpsg --description "open 22 and 80" --vpc-id $vpc_id --output text --query "GroupId")

# open 22,80 ports to all
aws ec2 authorize-security-group-ingress \
    --group-id $sg_id \
    --protocol tcp \
    --port 22 \
    --cidr '0.0.0.0/0'

aws ec2 authorize-security-group-ingress \
    --group-id $sg_id \
    --protocol tcp \
    --port 80 \
    --cidr '0.0.0.0/0'

# get the instance id
aws ec2 run-instances \
    --image-id $ami_id \
    --instance-type "t2.micro" \
    --key-name "my_id_rsa" \
    --security-group-ids $sg_id \
    --associate-public-ip-address

# using instance id fetch public ip
public_ip=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[0].Instances[0].PublicIpAddress" --output text) 
echo "http://${public_ip}"