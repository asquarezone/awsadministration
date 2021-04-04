#!/bin/bash

remove_trails() {
    echo $(echo $1 | tr -d '"')
}

# create_subnet 192.168.0.0/24 $VPC_ID 'tag'
create_subnet() {
    ID=$(aws ec2 create-subnet --cidr-block "$1" --tag-specifications  "ResourceType=subnet,Tags=[{Key=Name, Value=$3}]" --vpc-id $2 --query "Subnet.SubnetId")
    ID=$(remove_trails $ID)
    echo $ID
}

# create_routetable $VPC_ID 'public'
create_routetable() {
    ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id "$1" --tag-specifications  "ResourceType=route-table,Tags=[{Key=Name, Value=$2}]" --query "RouteTable.RouteTableId")
    ROUTE_TABLE_ID=$(remove_trails $ROUTE_TABLE_ID)
    echo $ROUTE_TABLE_ID
}

VPC_ID=$(aws ec2 create-vpc --cidr-block '192.168.0.0/16' --tag-specifications  "ResourceType=vpc,Tags=[{Key=Name, Value=vpcfromcli}]" --query "Vpc.VpcId")
VPC_ID=$(remove_trails $VPC_ID)
echo "Created VPC with id: ${VPC_ID}"


# Create subnets
SUBNET1_ID=$(create_subnet '192.168.0.0/24' $VPC_ID 'subnet1')
echo "Created Subnet1 with Subnetid $SUBNET1_ID"
SUBNET2_ID=$(create_subnet '192.168.1.0/24' $VPC_ID 'subnet2')
echo "Created Subnet2 with Subnetid $SUBNET2_ID"
SUBNET3_ID=$(create_subnet '192.168.2.0/24' $VPC_ID 'subnet3')
echo "Created Subnet3 with Subnetid $SUBNET3_ID"
SUBNET4_ID=$(create_subnet '192.168.3.0/24' $VPC_ID 'subnet4')
echo "Created Subnet4 with Subnetid $SUBNET4_ID"

# CREATE Route tables
PUBLIC_RT=$(create_routetable $VPC_ID 'public')

echo "Created Routetable public with Id $PUBLIC_RT"
PRIVATE_RT=$(create_routetable $VPC_ID 'private')
echo "Created Routetable private with Id $PRIVATE_RT"

