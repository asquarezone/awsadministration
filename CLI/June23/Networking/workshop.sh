#!/bin/bash
primary_region='us-west-2'
primary_region_cidr='10.0.0.0/16'
primary_subnet_1_cidr='10.0.0.0/24'
primary_subnet_2_cidr='10.0.1.0/24'
secondary_region='us-east-1'
secondary_region_cidr='10.1.0.0/16'
secondary_subnet_1_cidr='10.1.0.0/24'
secondary_subnet_2_cidr='10.1.1.0/24'

function create_vpc() {
    region=$1
    cidr=$2
    subnet_1_cidr=$3
    subnet_2_cidr=$4
    # Create  a vpc in primary region
    echo "Creating vpc in primary region: "

    # create vpc
    vpc_id=$(aws ec2 create-vpc \
        --region $region \
        --cidr-block $cidr \
        --query "Vpc.VpcId" \
        --output text)
    echo "created a vpc with ${vpc_id}"

    # Create subnets
    subnet_1_id=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --cidr-block ${subnet_1_cidr} \
        --availability-zone "${region}a" \
        --region $region \
        --query "Subnet.SubnetId" \
        --output text)

    echo "Created a subnet with subnet id ${subnet_1_id}"

    subnet_2_id=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --cidr-block ${subnet_2_cidr} \
        --availability-zone "${region}b" \
        --region $region \
        --query "Subnet.SubnetId" \
        --output text)
    echo "Created a subnet with subnet id ${subnet_2_id}"

    # Create internet gateway
    igw_id=$(aws ec2 create-internet-gateway \
        --query "InternetGateway.InternetGatewayId" \
        --region $region \
        --output text)


    # attach internet gateway
    aws ec2 attach-internet-gateway \
        --internet-gateway-id ${igw_id} \
        --vpc-id ${vpc_id} \
        --region $region

    echo "Created internet gateway with id ${igw_id} and attached to vpc: ${vpc_id}"

    # create a route table
    rt_id=$(aws ec2 create-route-table \
        --vpc-id ${vpc_id} \
        --query "RouteTable.RouteTableId" \
        --region $region \
        --output text)
    echo "Created a route table ${rt_id} and associated with subnets"

    aws ec2 create-route \
        --route-table-id ${rt_id} \
        --destination-cidr-block '0.0.0.0/0' \
        --region $region \
        --gateway-id ${igw_id}

    aws ec2 associate-route-table \
        --route-table-id ${rt_id} \
        --region $region \
        --subnet-id ${subnet_1_id}

    aws ec2 associate-route-table \
        --route-table-id ${rt_id} \
        --region $region \
        --subnet-id ${subnet_2_id}

    echo "Created a route table ${rt_id} and associated with subnets"

}

# create a vpc in primary region
create_vpc $primary_region $primary_region_cidr $primary_subnet_1_cidr $primary_subnet_2_cidr

# Create a vpc in secondary
create_vpc $secondary_region $secondary_region_cidr $secondary_subnet_1_cidr $secondary_subnet_2_cidr

