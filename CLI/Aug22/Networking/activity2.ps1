aws ec2 create-vpc `
    --cidr-block "192.168.0.0/24" `
    --region "us-west-2" `
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=oregon}]"
# vpc-0700740f60eb17406

aws ec2 create-subnet `
    --region "us-west-2" `
    --vpc-id "vpc-0700740f60eb17406"`
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=subnet}]" `
    --cidr-block "192.168.0.0/24"
# subnet-0764a3afa232308a1

aws ec2 create-route-table `
    --region "us-west-2" `
    --vpc-id "vpc-0700740f60eb17406"`
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=oregonrt}]"

# rtb-0fd1cf40fb3c15796

aws ec2 associate-route-table `
    --region "us-west-2" `
    --route-table-id "rtb-0fd1cf40fb3c15796" `
    --subnet-id "subnet-0764a3afa232308a1"

# rtbassoc-0bc14188fb2040e2c


aws ec2 create-vpc `
    --cidr-block "192.168.1.0/24" `
    --region "ap-south-1" `
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=mumbai}]"
# vpc-014e62bf7d6d88f7b

aws ec2 create-internet-gateway `
    --region "ap-south-1" `
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=mumbaiigw}]"
#igw-0c2088c80f9438bca

aws ec2 attach-internet-gateway `
    --internet-gateway-id "igw-0c2088c80f9438bca" `
    --vpc-id "vpc-014e62bf7d6d88f7b" `
    --region "ap-south-1"


aws ec2 create-subnet `
    --vpc-id "vpc-014e62bf7d6d88f7b" `
    --region "ap-south-1" `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=subnet}]" `
    --cidr-block "192.168.1.0/24"
# subnet-0995869dcd6fac56e

aws ec2 create-route-table `
    --region "ap-south-1" `
    --vpc-id "vpc-014e62bf7d6d88f7b" `
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=mumbairt}]"
# rtb-0a1844e3fd2be66d0

aws ec2 associate-route-table `
    --region "ap-south-1" `
    --subnet-id "subnet-0995869dcd6fac56e" `
    --route-table-id "rtb-0a1844e3fd2be66d0"

# rtbassoc-0edec4844256bbc7c

aws ec2 create-route `
    --region "ap-south-1" `
    --gateway-id "igw-0c2088c80f9438bca" `
    --destination-cidr-block "0.0.0.0/0" `
    --route-table-id "rtb-0a1844e3fd2be66d0"


aws ec2 create-vpc-peering-connection `
    --vpc-id "vpc-0700740f60eb17406" `
    --peer-vpc-id "vpc-014e62bf7d6d88f7b" `
    --peer-region "ap-south-1"

# "VpcPeeringConnectionId": "pcx-0e0bb940ee2ac85e5"

aws ec2 accept-vpc-peering-connection `
    --region "ap-south-1" `
    --vpc-peering-connection-id "pcx-0e0bb940ee2ac85e5"

# create route in us-west-2 route table to 
# forward traffic to 192.168.1.0/24 to peering connnection object
aws ec2 create-route `
    --region "us-west-2" `
    --route-table-id "rtb-0fd1cf40fb3c15796" `
    --destination-cidr-block "192.168.1.0/24" `
    --vpc-peering-connection-id "pcx-0e0bb940ee2ac85e5"


# create route in ap-south-1 route table to 
# forward traffic to 192.168.0.0/24 to peering connnection object

aws ec2 create-route `
    --region "ap-south-1" `
    --route-table-id "rtb-0a1844e3fd2be66d0" `
    --destination-cidr-block "192.168.0.0/24" `
    --vpc-peering-connection-id "pcx-0e0bb940ee2ac85e5"






