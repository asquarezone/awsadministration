#!/bin/bash

# ensure security group is present
SECURITY_GROUP_NAME=rds-mysql

# if the security group exists we get the name
result=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" --query "SecurityGroups[0].GroupName" --output=text)

if [[ $result == $SECURITY_GROUP_NAME ]]; then
    echo "Security group exists"
else
    echo "Create a security group with name $SECURITY_GROUP_NAME"
    exit 1
fi
