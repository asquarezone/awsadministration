#!/bin/bash

# Creating a vpc with aws cli
# aws ec2 create-vpc --cidr-block '10.100.0.0/16' --tag-specifications 'ResourceType=vpc,Tags=[{Key="Name",Value="ntier"}]'
# vpc-id = vpc-06e51523894dde898

vpcid=$(aws ec2 describe-vpcs --filter 'Name=cidr,Values=10.100.0.0/16' --query 'Vpcs[0].VpcId')


# Create web subnet
aws ec2 create-subnet --cidr-block '10.100.0.0/24'  --vpc-id $vpcid --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="web"}]'

# Create app subnet
aws ec2 create-subnet --cidr-block '10.100.1.0/24'  --vpc-id "$vpcid" --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="app"}]'

# Create db subnet
aws ec2 create-subnet --cidr-block '10.100.2.0/24'  --vpc-id "$vpcid" --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="db"}]'

# Create mgmt subnet
aws ec2 create-subnet --cidr-block '10.100.3.0/24'  --vpc-id "$vpcid" --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="mgmt"}]'
