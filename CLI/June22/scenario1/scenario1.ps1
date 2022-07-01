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

