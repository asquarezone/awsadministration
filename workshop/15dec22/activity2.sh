#!/bin/bash
for policy_arn in $(aws iam list-policies --scope Local --query 'Policies[].Arn' --output text)
do
    # lets get first arn
    echo "The policy arn to be deleted is ${policy_arn}"
    aws iam delete-policy --policy-arn ${policy_arn} --output text
    echo "The policy arn is successfully deleted"
done