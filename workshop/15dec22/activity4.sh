#!/bin/bash

for instance_id in $(aws ec2 describe-instances --filters "Name=tag:Env,Values=test" --query "Reservations[].Instances[].InstanceId" --output text)
do
    echo "stopping instance with instance id ${instance_id}"
    aws ec2 stop-instances --instance-ids ${instance_id}
    sleep 1s
    curent_state=$(aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[].Instances[].State.Name|[0]" --output text)
    echo "The current state is ${curent_state} for ec2 instance with id ${instance_id}"
done

# for instance_id in $(aws ec2 describe-instances --filters "Name=tag:Env,Values=test" --query "Reservations[].Instances[].InstanceId" --output text)
# do
#     echo "stopping instance with instance id ${instance_id}"
#     aws ec2 start-instances --instance-ids ${instance_id}
#     sleep 1s
#     curent_state=$(aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[].Instances[].State.Name|[0]" --output text)
#     echo "The current state is ${curent_state} for ec2 instance with id ${instance_id}"
# done