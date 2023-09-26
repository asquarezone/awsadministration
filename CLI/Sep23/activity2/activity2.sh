#!/bin/bash

# get_default_vpc_id()
# This function gets the default vpc id
function get_default_vpc_id() 
{
    vpc_id=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query "Vpcs[].VpcId" --output text)
    echo $vpc_id
}

# get_subnet_ids(vpc_id)
# This function gets the subnet ids based on vpc's passed
function get_subnet_ids()
{
    vpc_id=$1
    subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query "Subnets[].SubnetId" --output text)
    echo $subnets
}

subnet_group_name='custom'
subnet_ids=$(get_subnet_ids $(get_default_vpc_id))
echo "creating subnet group with ids ${subnet_ids}"
aws rds create-db-subnet-group \
    --db-subnet-group-name $subnet_group_name \
    --db-subnet-group-description "created from cli" \
    --subnet-ids $subnet_ids \
    --query "DBSubnetGroup.DBSubnetGroupName"
echo "Created subnet group"


