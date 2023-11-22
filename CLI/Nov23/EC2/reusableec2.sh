#!/bin/bash

#./reusableec2.sh "us-east-1" "vpc-cd32bcb0" "subnet-15ede058" "sg-0bdd39a6be616d961 sg-0f67708d44b7f6cb1" "id_rsa" "ami-0fc5d935ebf8bc3bc" "t2.micro"

# if [[ $# -ne 7 ]]; then
#     echo "This script needs 7 arguments"
#     echo ./reusableec2.sh "<region>" "<vpc-id>" "<subnet-id>" "<security-group-id>" "<key-name>" "<ami-id>" "<instance-type>"
#     exit 1
# fi

# --region
REGION="us-east-1"


# This script will not 
# create vpc, rather uses existing one
# --vpc-id
VPC_ID="vpc-cd32bcb0"
# create subnet rather uses exiting one
# --subnet-id
SUBNET_ID="subnet-15ede058"
# create security groups rather uses existing
# --sg-ids
SECURITY_GROUP_IDS="sg-0bdd39a6be616d961 sg-0f67708d44b7f6cb1"
# create key pairs rather uses existing keys
# --key-name
KEY_NAME="id_rsa"

# will create ec2 instance of AMI of your choice
## --ami
AMI_ID="ami-0fc5d935ebf8bc3bc"
## --instance-type
INSTANCE_TYPE="t2.micro"

containsSubstring() {
   local pattern="$1"
   local value="$2"
   if [[ $value == $pattern* ]]; then
           return 0
   else
           return 1
   fi
}



while [[ $# -ne 0 ]]; do
    case "$1" in
        --region)
            REGION=$2
            shift
            shift
            ;;
        --vpc-id)
            VPC_ID=$2
            shift
            shift
            ;;
        --subnet-id)
            SUBNET_ID=$2
            shift
            shift
            ;;
        --sg-ids)
            SECURITY_GROUP_IDS="$2"
            shift
            shift
            ;;
        --key-name)
            KEY_NAME=$2
            shift
            shift
            ;;
        --ami)
            AMI_ID=$2
            shift
            shift
            ;;
        --instance-type)
            INSTANCE_TYPE=$2
            shift
            shift
            ;;

        *)
            echo "Usage: reusableec2.sh --region <region-value> --vpc-id <your-vpc-id> --subnet-id <your-subnet-id>"
            exit 0
            ;;
esac

done
AZ="${REGION}a"
isValidVpc() {
    if containsSubstring "vpc-" "$VPC_ID" ; then
        
        return 0
    else
        echo "enter valid vpc"
        return 1
    fi
}
isValidSubnet() {
    # fix this
    return 0
}
isValidAMI() {
    # fix this
    return 0
}

if isValidVpc && isValidSubnet && isValidAMI ; then

    echo "aws ec2 run-instances \
        --instance-type ${INSTANCE_TYPE} \
        --key-name ${KEY_NAME} \
        --security-group-ids ${SECURITY_GROUP_IDS} \
        --subnet-id ${SUBNET_ID} \
        --image-id ${AMI_ID} \
        --region ${REGION} \
    "


    # Create an ec2 instance
    aws ec2 run-instances \
        --instance-type ${INSTANCE_TYPE} \
        --key-name ${KEY_NAME} \
        --security-group-ids ${SECURITY_GROUP_IDS} \
        --subnet-id ${SUBNET_ID} \
        --image-id ${AMI_ID} \
        --region "${REGION}"
    exit 0
else
    echo "enter valid values"
    exit 1
fi
