#!/bin/bash
region=$1
image_name="RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2"
owner_id="309956199498"
default_region='us-west-2'
group_name='openall'
publickey_filename="id_rsa.pub"
key_name="my-id-rsa"
instance_type="t2.micro"
instance_count=1
default_user_name="ec2-user"
# if region is not passed make us-west-2 as default region
if [[ -z "$region" ]]; then
  echo "region is not passed so ${default_region} will be considered"
  region=$default_region
fi
az="${region}b"

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





