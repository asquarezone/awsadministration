#!/bin/bash
set -ex
# ensure security group is present
SECURITY_GROUP_NAME=rds-mysql

# if the security group exists we get the name
result=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" --query "SecurityGroups[0].GroupName" --output=text)

if [[ $result == $SECURITY_GROUP_NAME ]]; then
    echo "Security group exists"
else
    echo "Create a security group with name $SECURITY_GROUP_NAME"
    exit 1
fi
# get the security group id
sg_id=$(aws ec2 describe-security-groups --filters "Name=group-name, Values=$SECURITY_GROUP_NAME" --query "SecurityGroups[0].GroupId" --output=text)

engine='mysql'
db_id='ltrdslibrarydb'
size=db.t3.micro
username=qtdevops
password=qtdevops123
storage=20

aws rds create-db-instance \
    --db-name 'library' \
    --db-instance-identifier $db_id \
    --db-instance-class $size \
    --master-username $username \
    --master-user-password $password \
    --vpc-security-group-ids $sg_id \
    --engine $engine \
    --allocated-storage $storage


# wait for the db instance to be available
aws rds wait db-instance-available --db-instance-identifier $db_id


# create a database snapshot
aws rds create-db-snapshot \
    --db-instance-identifier $db_id \
    --db-snapshot-identifier "$db_id-snapshot-1"

# wait for the snapshot to be available
aws rds wait db-snapshot-available --db-snapshot-identifier "$db_id-snapshot-1"

# delete the db instance
aws rds delete-db-instance \
    --db-instance-identifier $db_id \
    --skip-final-snapshot




