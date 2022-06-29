$region = "ap-south-1"

$vpcid= aws ec2 create-vpc `
    --cidr-block "10.0.0.0/16" `
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=fromcli}]" `
    --region $region `
    --query "Vpc.VpcId"`
    --output "text"

Write-Host "Create a vpc with id $vpcid"


$websubnetid = aws ec2 create-subnet `
    --vpc-id $vpcid `
    --cidr-block "10.0.0.0/24" `
    --availability-zone "ap-south-1a" `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=web}]" `
    --region $region `
    --query "Subnet.SubnetId" `
    --output "text"

Write-Host "Create a web subnet with id $websubnetid"

aws ec2 delete-subnet --subnet-id $websubnetid --region $region

aws ec2 delete-vpc --vpc-id $vpcid --region $region

