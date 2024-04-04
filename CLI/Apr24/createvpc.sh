#!/bin/bash

REGION="ap-south-1"

# create vpc
vpc_id=$(aws ec2 create-vpc --cidr-block "192.168.0.0/16" \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=learning}]" \
    --query "Vpc.VpcId" \
    --output text \
    --region ${REGION} \
    )

echo "VPC ID: ${vpc_id}"


web1_subnet=$(aws ec2 create-subnet \
    --vpc-id ${vpc_id} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-1}]" \
    --cidr-block "192.168.0.0/24" \
    --availability-zone "${REGION}a" \
    --output text \
    --region ${REGION} \
    --query "Subnet.SubnetId")

echo "Web 1 Subnet ID: ${web1_subnet}"

web2_subnet=$(aws ec2 create-subnet \
    --vpc-id ${vpc_id} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-2}]" \
    --cidr-block "192.168.1.0/24" \
    --availability-zone "${REGION}b" \
    --output text \
    --region ${REGION} \
    --query "Subnet.SubnetId")

echo "Web 2 Subnet ID: ${web2_subnet}"


db1_subnet=$(aws ec2 create-subnet \
    --vpc-id ${vpc_id} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-1}]" \
    --cidr-block "192.168.2.0/24" \
    --availability-zone "${REGION}a" \
    --output text \
    --region ${REGION} \
    --query "Subnet.SubnetId")

echo "DB 1 Subnet ID: ${db1_subnet}"



db2_subnet=$(aws ec2 create-subnet \
    --vpc-id ${vpc_id} \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-2}]" \
    --cidr-block "192.168.3.0/24" \
    --availability-zone "${REGION}b" \
    --output text \
    --region ${REGION} \
    --query "Subnet.SubnetId")

echo "DB 2 Subnet ID: ${db2_subnet}"


