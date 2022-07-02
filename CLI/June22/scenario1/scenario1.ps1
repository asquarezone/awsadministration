$vpc_cidr='192.168.0.0/16'
$vpc_id=aws ec2 create-vpc --cidr-block $vpc_cidr --query "Vpc.VpcId" --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=ntier}]" --output text
Write-Host "Vpc with cidr $vpc_cidr is created with id $vpc_id"
$az_a_subnets=@('web1', 'app1', 'db1')
$az_a_subnets_cidrs=@('192.168.0.0/24', '192.168.2.0/24', '192.168.4.0/24')
$az_b_subnets=@('web2', 'app2', 'db2')
$az_b_subnets_cidrs=@('192.168.1.0/24', '192.168.3.0/24', '192.168.5.0/24')

for ($index = 0; $index -lt $az_a_subnets.Count; $index++) {
    $subnet_name = $az_a_subnets[$index]
    aws ec2 create-subnet --vpc-id $vpc_id --availability-zone "us-west-2a" --cidr-block $az_a_subnets_cidrs[$index] --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$subnet_name}]"
}

for ($index = 0; $index -lt $az_b_subnets.Count; $index++) {
    $subnet_name = $az_b_subnets[$index]
    aws ec2 create-subnet --vpc-id $vpc_id --availability-zone "us-west-2b" --cidr-block $az_b_subnets_cidrs[$index] --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$subnet_name}]"
}


$igw_id=aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=ntier}]" --query "InternetGateway.InternetGatewayId" --output "text"

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id
Write-Host "Created internet gateway with id $igw_id and attached to vpc"

$public_rt_id=aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=public}]" --query "RouteTable.RouteTableId" --output "text"

aws ec2 create-route --destination-cidr-block "0.0.0.0/0" --route-table-id "$public_rt_id" --gateway-id $igw_id

Write-Host "Created public route table with id $public_rt_id"

$web1_subnet_cidr=$az_a_subnets_cidrs[0]
$web1_subnet_id= aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$web1_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text

$web2_subnet_cidr=$az_b_subnets_cidrs[0]
$web2_subnet_id= aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$web2_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text

aws ec2 associate-route-table --route-table-id $public_rt_id --subnet-id $web1_subnet_id
aws ec2 associate-route-table --route-table-id $public_rt_id --subnet-id $web2_subnet_id


# We need to fetch db1 subnet id
$db1_subnet_cidr=$az_a_subnets_cidrs[2]
$db1_subnet_id= aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$db1_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text
Write-Host "Found db1 subnet with id $db1_subnet_id"

# We need to fetch db2 subnet id
$db2_subnet_cidr=$az_b_subnets_cidrs[2]
$db2_subnet_id= aws ec2 describe-subnets --query "Subnets[?CidrBlock=='$db2_subnet_cidr' && VpcId=='$vpc_id'].SubnetId|[0]" --output text
Write-Host "Found db2 subnet with id $db2_subnet_id"

# db subnet group
aws rds create-db-subnet-group `
    --db-subnet-group-name "nterdbsubnet" `
    --db-subnet-group-description "ntier DB subnet group" `
    --subnet-ids $db1_subnet_id $db2_subnet_id

# db security group

$dbsg_id = aws ec2 create-security-group `
    --group-name "dbsg" `
    --description "My db Security group" `
    --vpc-id $vpc_id `
    --query "GroupId" `
    --output "text"

aws ec2 authorize-security-group-ingress `
    --group-id $dbsg_id `
    --protocol tcp `
    --port 3306 `
    --cidr $vpc_cidr

aws rds create-db-instance `
    --db-instance-identifier "ntier-qt-cli-instance" `
    --db-instance-class "db.t2.micro" `
    --engine "mysql" `
    --master-username "root" `
    --master-user-password "rootroot" `
    --allocated-storage 20 `
    --db-subnet-group-name "nterdbsubnet" `
    --vpc-security-group-ids $dbsg_id



# web security group

$websg_id = aws ec2 create-security-group `
    --group-name "ntierwebsg" `
    --description "ntier websg" `
    --vpc-id $vpc_id `
    --query "GroupId" `
    --output "text"

$ports=@(22,80,443)
for ($index = 0; $index -lt $ports.Count; $index++) {
    aws ec2 authorize-security-group-ingress `
        --group-id $websg_id `
        --protocol tcp `
        --port $ports[$index] `
        --cidr "0.0.0.0/0"
}

# AMI Id of ubuntu 22
$ami_id=aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609" --query "Images[0].ImageId" --output "text"

$keyname='docker'
# run the ec2 instance

$web_ec2_id=aws ec2 run-instances `
    --image-id $ami_id `
    --security-group-ids $websg_id `
    --associate-public-ip-address `
    --subnet-id $web1_subnet_id `
    --instance-type t2.micro `
    --key-name $keyname `
    --query "Instances[0].InstanceId" `
    --output 'text'

Write-Host "Ec2 instance created with id $web_ec2_id"
$username="ubuntu"
$public_ip=aws ec2 describe-instances `
    --instance-ids $web_ec2_id `
    --query "Reservations[].Instances[].PublicIpAddress|[0]" `
    --output "text"
Write-Host "Connect to the ec2 instance using ssh -i $keyname.pem $username@$public_ip"




