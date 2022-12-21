#!/bin/bash

function_return_value=""
function assign_default_value {
    function_return_value=""
    value=$1
    default_value=$2
    if [[ -z "$value" ]]; then
        function_return_value=$default_value
    else
        function_return_value=$value
    fi
}

# first argument region
assign_default_value $1 "us-west-2"
region=$function_return_value

# second argument image name
assign_default_value $2 "RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2"
image_name=$function_return_value

# third argument owner-id
assign_default_value $3 "309956199498"
owner_id=$function_return_value

group_name='openall'
publickey_filename="id_rsa.pub"
key_name="my-id-rsa"
instance_type="t2.micro"
default_user_name="ec2-user"

az="${region}b"
instance_count=1

ami_id=$(aws ec2 describe-images --filters "Name=name,Values=${image_name}" "Name=owner-id,Values=${owner_id}" --query "Images[].ImageId" --region "$region" --output text)
echo "Found Redhat 9 AMI: ${ami_id} in region ${region}"

vpc_id=$( aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId | [0]" --output text --region "${region}")
echo "Found vpc id: ${vpc_id} in region ${region}"

subnet_id=$(aws ec2 describe-subnets --filters "Name=availability-zone, Values=${az}" "Name=vpc-id, Values=${vpc_id}" --query "Subnets[].SubnetId | [0]" --output text --region "${region}")
echo "Found subnet in az: ${az} with id ${subnet_id}"

sg_id=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=${vpc_id}" --group-names "${group_name}" --query "SecurityGroups[].GroupId | [0]" --output text --region "${region}")
echo "Found security group in Vpc: ${vpc_id} with id ${sg_id} with name ${group_name}"

count=$(aws ec2 describe-key-pairs --filters "Name=key-name,Values=${key_name}" --query "KeyPairs[] | length(@)" --region ${region})
if [[ $count -eq 0 ]]; then
    echo "key pair ${key_name} doesnot exist, so creating"
    aws ec2 import-key-pair --key-name "${key_name}" --public-key-material "fileb://~/.ssh/${publickey_filename}"
fi

echo "key pair ${key_name} exists"

#todo: Add check for instance count
if [[ $instance_count -eq 0 ]]; then
    instance_id=$(aws ec2 run-instances --image-id "${ami_id}" --instance-type "${instance_type}" \
            --key-name "${key_name}" --subnet-id "${subnet_id}" \
            --security-group-ids "${sg_id}" --associate-public-ip-address \
            --region "${region}" --query "Instances[0].InstanceId" \
            --output text)
    echo "Created ec2 instance with instance id ${instance_id}"
fi

# get instance id and print ssh statement
#ip=$(aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress | [0]" --output text)
#echo "ssh ec2-user@${ip}"





