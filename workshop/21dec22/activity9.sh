#!/bin/bash
region=$1
image_name="RHEL-9.1.0_HVM-20221101-x86_64-2-Hourly2-GP2"
owner_id="309956199498"
default_region='ap-south-2'
# if region is not passed make ap-south-2 as default region
if [[ -z "$region" ]]; then
  echo "region is not passed so ${default_region} will be considered"
  region=$default_region
fi


ami_id=$(aws ec2 describe-images --filters "Name=name,Values=${image_name}" "Name=owner-id,Values=${owner_id}" --query "Images[].ImageId" --region "$region" --output text)
echo "Found ${ami_id}"