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


aws ec2 create-route-table `
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=publicrt}]" `
    --vpc-id "vpc-055037a4a184bf027"
# rtb-0950d0a7fa27a94dc

aws ec2 associate-route-table `
    --route-table-id "rtb-0950d0a7fa27a94dc" `
    --subnet-id "subnet-0f3662da86f2ef310"
# "AssociationId": "rtbassoc-0c0d9624e50a295fe"

aws ec2 create-route `
    --gateway-id "igw-0c2ff11b082892e37" `
    --destination-cidr-block "0.0.0.0/0" `
    --route-table-id "rtb-0950d0a7fa27a94dc"


aws ec2 create-route-table `
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=privatert}]" `
    --vpc-id "vpc-055037a4a184bf027"
# rtb-09865cd28840b608b


aws ec2 associate-route-table `
    --route-table-id "rtb-09865cd28840b608b" `
    --subnet-id "subnet-0df51903226e72ebe" `
#  "AssociationId": "rtbassoc-0a457385cd0e6998a"


aws ec2 create-security-group `
    --description  "web subnet security group" `
    --group-name "websg" `
    --vpc-id "vpc-055037a4a184bf027" `
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=websg}]"
# "sg-0219452a6ea21df4e"


aws ec2 authorize-security-group-ingress `
    --group-id "sg-0219452a6ea21df4e" `
    --protocol "tcp" `
    --port 22 `
    --cidr "0.0.0.0/0"

aws ec2 authorize-security-group-ingress `
    --group-id "sg-0219452a6ea21df4e" `
    --protocol "tcp" `
    --port 80 `
    --cidr "0.0.0.0/0"

aws ec2 authorize-security-group-ingress `
    --group-id "sg-0219452a6ea21df4e" `
    --protocol "tcp" `
    --port 443 `
    --cidr "0.0.0.0/0"


aws ec2 create-security-group `
    --description  "web subnet security group" `
    --group-name "dbsg" `
    --vpc-id "vpc-055037a4a184bf027" `
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=privatesg}]"
#sg-056809f4f5fb53523

aws ec2 authorize-security-group-ingress `
    --group-id "sg-056809f4f5fb53523" `
    --protocol "all" `
    --port 0-65535 `
    --cidr "192.168.0.0/23"










