# Create VPC
aws ec2 create-vpc --cidr-block "192.168.0.0/23" `
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=activity1}]"
# vpc-055037a4a184bf027


# Create internet gateway
aws ec2 create-internet-gateway `
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=activity1}]"
# igw-0c2ff11b082892e37

# attach internet gateway
aws ec2 attach-internet-gateway `
    --vpc-id "vpc-055037a4a184bf027" `
    --internet-gateway-id "igw-0c2ff11b082892e37"

# Create a public subnet

aws ec2 create-subnet `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=public}]" `
    --availability-zone "us-west-2a" `
    --cidr-block "192.168.0.0/24" `
    --vpc-id "vpc-055037a4a184bf027"
# subnet-0f3662da86f2ef310

aws ec2 create-subnet `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=private}]" `
    --availability-zone "us-west-2b" `
    --cidr-block "192.168.1.0/24" `
    --vpc-id "vpc-055037a4a184bf027"
# subnet-0df51903226e72ebe


