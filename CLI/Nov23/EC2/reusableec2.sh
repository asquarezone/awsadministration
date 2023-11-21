#!/bin/bash

REGION="us-east-1"
AZ="${REGION}a"

# This script will not 
# create vpc, rather uses existing one
VPC_ID="vpc-cd32bcb0"
# create subnet rather uses exiting one
SUBNET_ID="subnet-15ede058"
# create security groups rather uses existing
SECURITY_GROUP_IDS="sg-0bdd39a6be616d961 sg-0f67708d44b7f6cb1"
# create key pairs rather uses existing keys
KEY_NAME="id_rsa"

# will create ec2 instance of AMI of your choice
AMI_ID="ami-0fc5d935ebf8bc3bc"
INSTANCE_TYPE="t2.micro"


# Create an ec2 instance
aws ec2 run-instances \
    --instance-type ${INSTANCE_TYPE} \
    --key-name ${KEY_NAME} \
    --security-group-ids ${SECURITY_GROUP_IDS} \
    --subnet-id ${SUBNET_ID} \
    --image-id ${AMI_ID}

