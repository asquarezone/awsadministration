#!/bin/bash
region='ap-south-1'
vpcid=$(aws ec2 create-vpc \
    --cidr-block "10.0.0.0/16" \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=fromcli}]" \
    --query "Vpc.VpcId" \
    --region $region)


websubnetid=$(aws ec2 create-subnet \
    --vpc-id "vpc-04934e6b1d62ee5b3" \
    --cidr-block "10.0.0.0/24" \
    --availability-zone "${region}a" \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web}]" \
    --query "Subnet.SubnetId" \
    --region $region)

aws ec2 delete-subnet --subnet-id $websubnetid --region $region

aws ec2 delete-vpc --vpc-id $vpcid --region $region

