#!/bin/bash
# get all regions
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text)
do
    echo "Deleting security groups in region: ${region}"
    # get all vpcs
    for vpc_id in $(aws ec2 describe-vpcs --query "Vpcs[].VpcId" --region ${region} --output text)
    do
        echo "Deleting security groups in vpc id ${vpc_id}"
        # get all security groups
        for sg_id in $(aws ec2 describe-security-groups --region ${region} --filters "Name=vpc-id,Values=${vpc_id}" --query "SecurityGroups[?GroupName!='default'].GroupId" --output text)
        do
            echo "Deleting security group with id ${sg_id}"
            # delete the security group with sg_id
            aws ec2 delete-security-group --group-id $sg_id --region ${region}
        done
    done
done

