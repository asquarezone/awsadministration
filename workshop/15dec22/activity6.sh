#!/bin/bash

# get all the instance identifiers
for instance_identifier in $(aws rds describe-db-instances --query "DBInstances[].DBInstanceIdentifier" --output text)
do
    echo "dbinstance found with identifier ${instance_identifier}"
    aws rds delete-db-instance --db-instance-identifier ${instance_identifier} --delete-automated-backups --skip-final-snapshot
done