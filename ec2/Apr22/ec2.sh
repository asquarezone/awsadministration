#!/bin/bash

# lets find the ec2 key value pairs
keypair=$(aws ec2 describe-key-pairs --query "KeyPairs[0].KeyName")
keypair=${keypair:1:-1}
echo "Selected key pair is $keypair"

# lets find the security group
sg_id=$(aws ec2  describe-security-groups --group-names "openall" --query "SecurityGroups[0].GroupId")
sg_id=${sg_id:1:-1}
echo "Selected security group is ${sg_id}"

# lets find the ami id
ami_id=$(aws ec2 describe-images --filters "Name=owner-id,Values=099720109477" "Name=description, Values='Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on 2022-04-19'" --query "Images[0].ImageId" --output text) 

echo "Selected ami id id ${ami_id}"


instance_size="t2.micro"

aws ec2 run-instances --image-id $ami_id --instance-type $instance_size --key-name $keypair --security-group-ids $sg_id