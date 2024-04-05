#!/bin/bash

# ensure number of arguments passed are two
if [ $# -ne 2 ]; then
   echo "you have passed wrong arguments"
   echo "usage $0 <region> <action>"
   exit 1
fi

REGION=$1
ACTION=$2

if [ $ACTION != "create" ] && [ $ACTION != "delete" ]; then
    echo "as of now only create and delete actions are supported"
    exit 1
fi

if [ $ACTION == "create" ]; then
    # create vpc
    vpc_id=$(aws ec2 create-vpc --cidr-block "192.168.0.0/16" \
        --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=learning},{Key=CreatedBy,Value=cli}]" \
        --query "Vpc.VpcId" \
        --output text \
        --region ${REGION} \
        )

    echo "VPC ID: ${vpc_id}"


    web1_subnet=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-1},{Key=CreatedBy,Value=cli}]" \
        --cidr-block "192.168.0.0/24" \
        --availability-zone "${REGION}a" \
        --output text \
        --region ${REGION} \
        --query "Subnet.SubnetId")

    echo "Web 1 Subnet ID: ${web1_subnet}"

    web2_subnet=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web-2},{Key=CreatedBy,Value=cli}]" \
        --cidr-block "192.168.1.0/24" \
        --availability-zone "${REGION}b" \
        --output text \
        --region ${REGION} \
        --query "Subnet.SubnetId")

    echo "Web 2 Subnet ID: ${web2_subnet}"


    db1_subnet=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-1},{Key=CreatedBy,Value=cli}]" \
        --cidr-block "192.168.2.0/24" \
        --availability-zone "${REGION}a" \
        --output text \
        --region ${REGION} \
        --query "Subnet.SubnetId")

    echo "DB 1 Subnet ID: ${db1_subnet}"



    db2_subnet=$(aws ec2 create-subnet \
        --vpc-id ${vpc_id} \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db-2},{Key=CreatedBy,Value=cli}]" \
        --cidr-block "192.168.3.0/24" \
        --availability-zone "${REGION}b" \
        --output text \
        --region ${REGION} \
        --query "Subnet.SubnetId")

    echo "DB 2 Subnet ID: ${db2_subnet}"
elif [ $ACTION == "delete" ]; then
    # get all subnets matching tag CreatedBy=cli 
    subnets=$(aws ec2 describe-subnets \
        --region "${REGION}" \
        --filters "Name=tag:CreatedBy,Values=cli" \
        --query "Subnets[].SubnetId" \
        --output text)
    for subnet in ${subnets}; do
        aws ec2 delete-subnet \
            --subnet-id "${subnet}" \
            --region "${REGION}"
        echo "deleted subnet ${subnet}"
    done

    # get all vpcs
    vpcs=$(aws ec2 describe-vpcs \
        --region "${REGION}" \
        --filters "Name=tag:CreatedBy,Values=cli" \
        --query "Vpcs[].VpcId" --output text)
    for vpc in ${vpcs}; do
        aws ec2 delete-vpc \
            --vpc-id "${vpc}" \
            --region "${REGION}"
        echo "deleted vpc ${vpc}"
    done

fi


