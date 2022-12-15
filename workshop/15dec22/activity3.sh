#!/bin/bash
# aws ec2 run-instances \
#     --image-id ami-03b755af568109dc3 \
#     --instance-type t2.micro \
#     --key-name "my_id_rsa"

for instance_id in $(aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId " --output text)
do
    echo "instance id found is ${instance_id}"
    echo "applying tags to ${instance_id}"
    aws ec2 create-tags \
        --resources ${instance_id} \
        --tags "Key=Project,Value=qtworkshop" "Key=Env,Value=test" "Key=team,Value=qtaws" "Key=release,Value=v1.0"
done
