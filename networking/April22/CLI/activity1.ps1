# Create a vpc 
aws ec2 create-vpc --cidr-block '10.100.0.0/16' `
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=ntier}]'
# vpc-id: vpc-062e459271175202c

# create web1 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1a' `
    --cidr-block '10.100.0.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=web1}]'
# id: subnet-03237be9cccd77e2f

# create web2 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1b' `
    --cidr-block '10.100.1.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=web2}]'
# id: subnet-040664b2394a71799

# create app1 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1a' `
    --cidr-block '10.100.2.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=app1}]'
# id: subnet-00240f217d2dcb452

# create app2 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1b' `
    --cidr-block '10.100.3.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=app2}]'
# id: subnet-082b3a6b4c0128a69


# create db1 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1a' `
    --cidr-block '10.100.4.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=db1}]'
# id: subnet-0e846a198d9a6ca0c

# create db2 subnet
aws ec2 create-subnet --vpc-id 'vpc-062e459271175202c' --availability-zone 'ap-south-1b' `
    --cidr-block '10.100.5.0/24' `
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=db2}]'
# id: subnet-0eef6d79afd00b601


# Create internet gateway
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=ntierigw}]'
# id : igw-02118d53e4acbbfef

aws ec2 attach-internet-gateway `
    --internet-gateway-id 'igw-02118d53e4acbbfef' `
    --vpc-id 'vpc-062e459271175202c'