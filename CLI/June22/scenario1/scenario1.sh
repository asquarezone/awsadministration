#!/bin/bash
vpc_cidr='192.168.0.0/16'
vpc_id=$(aws ec2 create-vpc --cidr-block $vpc_cidr --query "Vpc.VpcId" --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=ntier}]" --output text)
echo "Vpc with cidr ${vpc_cidr} is created with id ${vpc_id}"

az_a_subnets=('web1' 'app1' 'db1')
az_a_subnets_cidrs=('192.168.0.0/24' '192.168.2.0/24' '192.168.4.0/24')

for index in ${!az_a_subnets[@]}; do
  subnet_name=${az_a_subnets[$index]}
  aws ec2 create-subnet --vpc-id $vpc_id --availability-zone "us-west-2a" --cidr-block ${az_a_subnets_cidrs[$index]} --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$subnet_name}]"
done 

az_b_subnets=('web2' 'app2' 'db2')
az_b_subnets_cidrs=('192.168.1.0/24' '192.168.3.0/24' '192.168.5.0/24')

for index in ${!az_b_subnets[@]}; do
  subnet_name=${az_b_subnets[$index]}
  aws ec2 create-subnet --vpc-id $vpc_id --availability-zone "us-west-2a" --cidr-block ${az_b_subnets_cidrs[$index]} --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$subnet_name}]"
done 

igw_id=$(aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=ntier}]" --query "InternetGateway.InternetGatewayId" --output "text")
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id
echo "Created internet gateway with id $igw_id and attached to vpc"

public_rt_id=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=public}]" --query "RouteTable.RouteTableId" --output "text")

aws ec2 create-route --destination-cidr-block "0.0.0.0/0" --route-table-id $public_rt_id --gateway-id $igw_id

echo "Created public route table with id $public_rt_id"

web1_subnet_cidr=$az_a_subnets_cidrs[0]
web1_subnet_id=$(aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$web1_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text)

web2_subnet_cidr=$az_b_subnets_cidrs[0]
web2_subnet_id=$(aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$web2_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text)

aws ec2 associate-route-table --route-table-id $public_rt_id --subnet-id $web1_subnet_id
aws ec2 associate-route-table --route-table-id $public_rt_id --subnet-id $web2_subnet_id

