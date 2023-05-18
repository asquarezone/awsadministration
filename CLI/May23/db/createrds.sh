#!/bin/bash

assign_default_if_empty() {
    if [[ -z $1 ]]; then
        echo $2
    else
        echo $1
    fi
}

# First argument DB_ENGINE
DB_ENGINE=$(assign_default_if_empty $1 'mysql')
# Second argument is DB_INSTANCE_CLASS
DB_INSTANCE_CLASS=$(assign_default_if_empty $2 'db.t2.micro')
# Third argument is DBINSTANCE_IDENTIFIER
DBINSTANCE_IDENTIFIER=$(assign_default_if_empty $3 'qtemployeesdbinst')
# Fourth argument is DB_NAME
DB_NAME=$(assign_default_if_empty $4 'employees')
# Fifth argument is username
USER_NAME=$(assign_default_if_empty $5 'root')
# sixth argument is password
USER_PASSWORD=$(assign_default_if_empty $6 'rootroot')
# 7 = size in gb
SIZE_IN_GB=$(assign_default_if_empty $7 20)
# 8 = Display output
DISPLAY_OUTPUT=$(assign_default_if_empty $8 'NO')

VPC_ID=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query "Vpcs[0].VpcId" --output text)
DBINSTANCE_IDENTIFIER='qtemployeesdbinst'
# DB_NAME='employees'
# SIZE_IN_GB=20
# DB_INSTANCE_CLASS='db.t2.micro'
# DB_ENGINE='mysql'
# USER_NAME='root'
# USER_PASSWORD='rootroot'
# DISPLAY_OUTPUT='NO'

echo "Found default vpc with id ${VPC_ID}"

# Get count of security groups with matching name
SG_COUNT=$(aws ec2 describe-security-groups --query "length(SecurityGroups[?GroupName=='mysqlsg'])")
if [[ $SG_COUNT == "0" ]]; then
    SG_ID=$(aws ec2 create-security-group \
        --description "rds mysql security group" \
        --group-name "mysqlsg" \
        --vpc-id ${VPC_ID}\
        --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=mysqlsg}]" \
        --query "GroupId" \
        --output text)
    echo "Created security group with id ${SG_ID}"
    ### Add 3306 open rule to every one
    OUTPUT=$(aws ec2 authorize-security-group-ingress \
        --group-id ${SG_ID} \
        --protocol tcp \
        --port 3306 \
        --cidr 0.0.0.0/0)

    if [[ $DISPLAY_OUTPUT != "NO" ]]; then
        echo $OUTPUT

    fi
else
    SG_ID=$(aws ec2 describe-security-groups \
        --query "SecurityGroups[?GroupName=='mysqlsg'].GroupId" \
        --output text)
    echo "Found security group with id ${SG_ID}"
fi

exit 0
# Create a mysql rds instance
OUTPUT=$(aws rds create-db-instance \
   --db-name ${DB_NAME} \
   --db-instance-identifier ${DBINSTANCE_IDENTIFIER} \
   --allocated-storage ${SIZE_IN_GB} \
   --db-instance-class ${DB_INSTANCE_CLASS} \
   --engine ${DB_ENGINE} \
   --master-username ${USER_NAME} \
   --master-user-password ${USER_PASSWORD} \
   --backup-retention-period 0 \
   --no-multi-az \
   --no-auto-minor-version-upgrade \
   --publicly-accessible \
   --vpc-security-group-ids ${SG_ID})

if [[ $DISPLAY_OUTPUT != "NO" ]]; then
    echo $OUTPUT
fi
    

