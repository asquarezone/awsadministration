echo "Creating vpc ntier1....."
ntier1_vpcid=$(aws ec2 create-vpc --cidr-block '10.100.0.0/16' \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=ntier1}]' \
    --query  'Vpc.{VpcId:VpcId}' --output text)
echo "VPC id is ${ntier1_vpcid}"

ntier1_subnet1_id=$(aws ec2 create-subnet --vpc-id ${ntier1_vpcid} --availability-zone 'us-west-2a' \
    --cidr-block '10.100.0.0/24' \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=web}]' \
    --query "Subnet.SubnetId" --output text)

echo "web subnet id is ${ntier1_subnet1_id}"

ntier1_subnet2_id=$(aws ec2 create-subnet --vpc-id ${ntier1_vpcid} --availability-zone 'us-west-2b' \
    --cidr-block '10.100.1.0/24' \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=app}]' \
    --query "Subnet.SubnetId" --output text)

echo "app subnet id is ${ntier1_subnet2_id}"

ntier1_igw=$(aws ec2 create-internet-gateway \
    --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=ntier1igw}]' \
    --query "InternetGateway.InternetGatewayId" --output text)

echo "igw id is ${ntier1_igw}"

aws ec2 attach-internet-gateway \
    --internet-gateway-id ${ntier1_igw} --vpc-id ${ntier1_vpcid}





ntier2_vpcid=$(aws ec2 create-vpc --cidr-block '10.101.0.0/16' \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=ntier1}]' \
    --query "Vpc.VpcId")






