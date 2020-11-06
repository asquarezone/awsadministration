#!/bin/bash

# Creating a vpc with aws cli
aws ec2 create-vpc --cidr-block '10.100.0.0/16' --tag-specifications 'ResourceType=vpc,Tags=[{Key="Name",Value="ntier"}]'
 #vpc-id =vpc-0f229c2da7f5e512d

#vpcid=$(aws ec2 describe-vpcs --filter 'Name=cidr,Values=10.100.0.0/16' --query 'Vpcs[0].VpcId')


# Create web subnet
aws ec2 create-subnet --cidr-block '10.100.0.0/24'  --vpc-id $vpc_id --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="web"}]' --availability-zone "us-west-2a"

# Create app subnet
aws ec2 create-subnet --cidr-block '10.100.1.0/24'  --vpc-id $vpc_id --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="app"}]' --availability-zone "us-west-2b"

# Create db subnet
aws ec2 create-subnet --cidr-block '10.100.2.0/24'  --vpc-id $vpc_id --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="db"}]' --availability-zone "us-west-2c"

# Create mgmt subnet
aws ec2 create-subnet --cidr-block '10.100.3.0/24'  --vpc-id $vpc_id --tag-specifications 'ResourceType=subnet,Tags=[{Key="Name",Value="mgmt"}]' --availability-zone "us-west-2a"

# Create internet gateway
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key="Name",Value="ntierigw"}]'

# attach interet-gateway with vpc
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id

# Create public route table
aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications 'ResourceType=route-table,Tags=[{Key="Name",Value="public"}]'

# Create private route table
aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications 'ResourceType=route-table,Tags=[{Key="Name",Value="private"}]'

# Create a route to igw for public route table
aws ec2 create-route --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id --route-table-id $pub_rt_id

aws ec2 associate-route-table --route-table-id $pub_rt_id  --subnet-id 'subnet-0372a28adcf6a733b'
aws ec2 associate-route-table --route-table-id $pub_rt_id  --subnet-id 'subnet-0456e0afc23996728'
aws ec2 associate-route-table --route-table-id $pri_rt_id  --subnet-id 'subnet-085e842b0137a2308'
aws ec2 associate-route-table --route-table-id $pri_rt_id  --subnet-id 'subnet-0dbc628a0a5daa03f'

# web Security Group
aws ec2 create-security-group --description 'web sg' --group-name 'web' --vpc-id $vpc_id  --tag-specifications 'ResourceType=security-group,Tags=[{Key="Name",Value="web"}]'

aws ec2 authorize-security-group-ingress --group-id sg-0b16a13e9892355a1 --protocol tcp --port 80 --cidr 0.0.0.0/0

# network acl
aws ec2 create-network-acl --vpc $vpc_id  --tag-specifications 'ResourceType=network-acl,Tags=[{Key="Name",Value="web-acl"}]'
#nacl_id=acl-04d687ee59684f6ee

aws ec2 create-network-acl-entry --network-acl-id acl-04d687ee59684f6ee --ingress --port-range From=80,To=80 --cidr-block 0.0.0.0/0 --rule-action allow --rule-number 100 --protocol tcp