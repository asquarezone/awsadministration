#!/bin/bash

# create vpc
aws ec2 create-vpc --cidr-block "192.168.0.0/16" \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=learning}]"
# "VpcId": "vpc-0c8dce26895aad631"

aws ec2 create-subnet \
    --vpc-id "vpc-0c8dce26895aad631" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-1}]" \
    --cidr-block "192.168.0.0/24" \
    --availability-zone "ap-south-1a"
# "SubnetId": "subnet-07da393b476ad026c"

aws ec2 create-subnet \
    --vpc-id "vpc-0c8dce26895aad631" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-2}]" \
    --cidr-block "192.168.1.0/24" \
    --availability-zone "ap-south-1b"
# "SubnetId": "subnet-08f583ea4e59cbb45"


aws ec2 create-subnet \
    --vpc-id "vpc-0c8dce26895aad631" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-1}]" \
    --cidr-block "192.168.2.0/24" \
    --availability-zone "ap-south-1a"
# "SubnetId": "subnet-03099cecc88e01bba"


aws ec2 create-subnet \
    --vpc-id "vpc-0c8dce26895aad631" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-2}]" \
    --cidr-block "192.168.3.0/24" \
    --availability-zone "ap-south-1b"
# "SubnetId": "subnet-02389377f4f2bc596"

