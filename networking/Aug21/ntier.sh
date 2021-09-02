#!/bin/bash

aws ec2 create-vpc --cidr-block '192.168.0.0/16' --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=ntier}]"
# "VpcId": "vpc-04acb61dbc8b814c7"

aws ec2 create-subnet --cidr-block '192.168.0.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web1}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2a"
# "SubnetId": "subnet-0b8b36e0ae7a2b040"

