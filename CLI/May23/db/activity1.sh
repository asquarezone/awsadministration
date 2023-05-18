#!/bin/bash

aws ec2 create-security-group \
    --description "rds mysql security group" \
    --group-name "mysqlsg" \
    --vpc-id "vpc-0263a09e73d00080c"\
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=mysqlsg}]"

# {
#     "GroupId": "sg-08bcb448f727c9e96",
#     "Tags": [
#         {
#             "Key": "Name",
#             "Value": "mysqlsg"
#         }
#     ]
# }

### Add 3306 open rule to every one
aws ec2 authorize-security-group-ingress \
    --group-id sg-08bcb448f727c9e96 \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
# {
#     "Return": true,
#     "SecurityGroupRules": [
#         {
#             "SecurityGroupRuleId": "sgr-0c0e32b5788018104",
#             "GroupId": "sg-08bcb448f727c9e96",
#             "GroupOwnerId": "678879106782",
#             "IsEgress": false,
#             "IpProtocol": "tcp",
#             "FromPort": 3306,
#             "ToPort": 3306,
#             "CidrIpv4": "0.0.0.0/0"
#         }
#     ]
# }

# Create a mysql rds instance

aws rds create-db-instance \
   --db-name 'employees' \
   --db-instance-identifier 'qtemployeesdbinst' \
   --allocated-storage 20 \
   --db-instance-class "db.t2.micro" \
   --engine "mysql" \
   --master-username "root" \
   --master-user-password "rootroot" \
   --backup-retention-period 0 \
   --no-multi-az \
   --no-auto-minor-version-upgrade \
   --publicly-accessible \
   --vpc-security-group-ids "sg-08bcb448f727c9e96"

# {
#     "DBInstance": {
#         "DBInstanceIdentifier": "qtemployeesdbinst",
#         "DBInstanceClass": "db.t2.micro",
#         "Engine": "mysql",
#         "DBInstanceStatus": "creating",
#         "MasterUsername": "root",
#         "DBName": "employees",
#         "AllocatedStorage": 20,
#         "PreferredBackupWindow": "21:33-22:03",
#         "BackupRetentionPeriod": 0,
#         "DBSecurityGroups": [],
#         "VpcSecurityGroups": [
#             {
#                 "VpcSecurityGroupId": "sg-08bcb448f727c9e96",
#                 "Status": "active"
#             }
#         ],
#         "DBParameterGroups": [
#             {
#                 "DBParameterGroupName": "default.mysql8.0",
#                 "ParameterApplyStatus": "in-sync"