#!/bin/bash

instanceIds=$(aws ec2 describe-instances --filters "Name=tag:Env,Values=QA" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text)
echo "The instance ids which will be shutdown are ${instanceIds}"
aws ec2 stop-instances --instance-ids ${instanceIds}
