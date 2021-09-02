#!/bin/bash

aws ec2 create-vpc --cidr-block '192.168.0.0/16' --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=ntier}]"
# "VpcId": "vpc-04acb61dbc8b814c7"

aws ec2 create-subnet --cidr-block '192.168.0.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web1}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2a"
# "SubnetId": "subnet-0b8b36e0ae7a2b040"


aws ec2 create-subnet --cidr-block '192.168.1.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web2}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2b"
#"SubnetId": "subnet-0157da4c7a92eb1d9"


aws ec2 create-subnet --cidr-block '192.168.2.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=app1}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2a"
# "SubnetId": "subnet-063a24cd079bc5ff6"


aws ec2 create-subnet --cidr-block '192.168.3.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=app2}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2b"
# "SubnetId": "subnet-0f50fceb36b1c4833"


aws ec2 create-subnet --cidr-block '192.168.4.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db1}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2a"
# "SubnetId": "subnet-014b090887965363c"


aws ec2 create-subnet --cidr-block '192.168.5.0/24' --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=db2}]" --vpc-id "vpc-04acb61dbc8b814c7" --availability-zone "us-west-2b"
# "SubnetId": "subnet-0ecd212a19a0427ae"

aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=ntierigw}]"
# "InternetGatewayId": "igw-09baaac90b9e1aaf6"

aws ec2 attach-internet-gateway --internet-gateway-id "igw-09baaac90b9e1aaf6" --vpc-id "vpc-04acb61dbc8b814c7"




