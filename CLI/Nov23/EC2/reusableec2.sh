#!/bin/bash

#./reusableec2.sh "us-east-1" "vpc-cd32bcb0" "subnet-15ede058" "sg-0bdd39a6be616d961 sg-0f67708d44b7f6cb1" "id_rsa" "ami-0fc5d935ebf8bc3bc" "t2.micro"

if [[ $# -ne 7 ]]; then
    echo "This script needs 7 arguments"
    echo ./reusableec2.sh "<region>" "<vpc-id>" "<subnet-id>" "<security-group-id>" "<key-name>" "<ami-id>" "<instance-type>"
    exit 1
fi

REGION=$1
#"us-east-1"
AZ="${REGION}a"

# This script will not 
# create vpc, rather uses existing one
VPC_ID=$2
#"vpc-cd32bcb0"
# create subnet rather uses exiting one
SUBNET_ID=$3
#"subnet-15ede058"
# create security groups rather uses existing
SECURITY_GROUP_IDS=$4
#"sg-0bdd39a6be616d961 sg-0f67708d44b7f6cb1"
# create key pairs rather uses existing keys
KEY_NAME=$5
#"id_rsa"

# will create ec2 instance of AMI of your choice
AMI_ID=$6
#"ami-0fc5d935ebf8bc3bc"
INSTANCE_TYPE=$7
#"t2.micro"

echo "aws ec2 run-instances \
    --instance-type ${INSTANCE_TYPE} \
    --key-name ${KEY_NAME} \
    --security-group-ids ${SECURITY_GROUP_IDS} \
    --subnet-id ${SUBNET_ID} \
    --image-id ${AMI_ID} \
"


# Create an ec2 instance
aws ec2 run-instances \
    --instance-type ${INSTANCE_TYPE} \
    --key-name ${KEY_NAME} \
    --security-group-ids ${SECURITY_GROUP_IDS} \
    --subnet-id ${SUBNET_ID} \
    --image-id ${AMI_ID}

