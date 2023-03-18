#!bin/bash

# This function will set the default value to the first argument if it is empty
function set_default_if_empty() {
    value=$1
    # if user doesnot pass default value as 1 argument assign second argument as default
    if [[ -z $value ]]; then
        value=$2
    fi
    echo $value
}

# This function gets instance ids by tags
function get_instance_ids_by_tags() {
    tag_name=$(set_default_if_empty $1 Env)
    tag_value=$(set_default_if_empty $2 QA)
    instanceIds=$(aws ec2 describe-instances --filters "Name=tag:${tag_name},Values=${tag_value}" --query "Reservations[].Instances[].InstanceId" --output text)
    echo $instanceIds
}

instance_type=$(set_default_if_empty $3 t2.nano)


# get instance ids based on tags
instance_ids=$(get_instance_ids_by_tags $1 $2)
for instance_id in $instance_ids
do
    echo "Resizing instance id ${instance_id}"
    aws ec2 modify-instance-attribute --instance-id $instance_id --instance-type ${instance_type}
done





