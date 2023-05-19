#!/bin/bash

# lets process arguments
DBINSTANCE_IDENTIFIER="qtmysqlsrv"
DB_ENGINE='mysql'
DB_INSTANCE_CLASS='db.t2.micro'
USER_NAME='root'
USER_PASSWORD='rootroot'
DB_NAME='sample'
SIZE_IN_GB=20
DISPLAY_OUTPUT='NO'
BACKUP_PERIOD=0
IS_READ_REPLICA_REQUIRED=0
READ_REPLICA_REGION='us-west-2'
while (( $# )); do
    if [[ $1 == "--name" ]]; then
        DBINSTANCE_IDENTIFIER=$2
    elif [[ $1 == "--engine" ]]; then
        DB_ENGINE=$2
    elif [[ $1 == "--instance-class" ]]; then
        DB_INSTANCE_CLASS=$2
    elif [[ $1 == "--username" ]]; then
        USER_NAME=$2
    elif [[ $1 == "--password" ]]; then
        USER_PASSWORD=$2
    elif [[ $1 == "--size" ]]; then
        SIZE_IN_GB=$2
    elif [[ $1 == "--display-output" ]]; then
        DISPLAY_OUTPUT=$2
    elif [[ $1 == "--db-name" ]]; then
        DB_NAME=$2
    elif [[ $1 == "--backup-in-days" ]]; then
        BACKUP_PERIOD=$2
    else
        echo "This script creates rds instance"
        echo "usage: "
        echo "./createrdsnamed.sh --name <db-instance-identifier> 
            --username <username> --password <password> \
            --engine <engine-name> --instance-class <instanceclass> \
            --size <size in gb> --db-name <name of your db> \
            --display-output <NO/YES>"
        echo "\n \n default values are"
        echo "aws rds create-db-instance \
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
    --publicly-accessible"
        
        exit
    fi
    shift
    shift
done
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query "Vpcs[0].VpcId" --output text)

echo "Found default vpc with id ${VPC_ID}"

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

RDS_INSTANCE_COUNT=$(aws rds describe-db-instances --query "length(DBInstances[?DBInstanceIdentifier=='${DBINSTANCE_IDENTIFIER}'])" )

if [[ $RDS_INSTANCE_COUNT == '0' ]]; then

    # Create a mysql rds instance
    OUTPUT=$(aws rds create-db-instance \
    --db-name ${DB_NAME} \
    --db-instance-identifier ${DBINSTANCE_IDENTIFIER} \
    --allocated-storage ${SIZE_IN_GB} \
    --db-instance-class ${DB_INSTANCE_CLASS} \
    --engine ${DB_ENGINE} \
    --master-username ${USER_NAME} \
    --master-user-password ${USER_PASSWORD} \
    --backup-retention-period ${BACKUP_PERIOD} \
    --no-multi-az \
    --no-auto-minor-version-upgrade \
    --publicly-accessible \
    --vpc-security-group-ids ${SG_ID})

    if [[ $DISPLAY_OUTPUT != "NO" ]]; then
        echo $OUTPUT
    fi
else
    echo "Found db instance with name ${DBINSTANCE_IDENTIFIER}"
fi  