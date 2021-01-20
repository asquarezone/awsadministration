#!/bin/bash

# This file will contain simple commands that can be executed to create rds
# instances and configuring them
aws rds create-db-instance --db-instance-identifier 'qtrdsfromcli' --allocated-storage 20 --db-instance-class 'db.t2.micro' --engine 'mysql' --master-username 'admin' --master-user-password 'admin1234' --vpc-security-group-ids "sg-075892da85bd09fc0" --backup-retention-period 7 --port 3306 --no-multi-az --no-auto-minor-version-upgrade

aws rds describe-db-instances

aws rds describe-db-instances --db-instance-identifier 'qtrdsfromcli'

# Create a db snapshot
aws rds create-db-snapshot --db-instance-identifier 'qtrdsfromcli' --db-snapshot-identifier 'snapshotfromcli'

aws rds describe-db-snapshots 

aws rds describe-db-snapshots --query "DBSnapshots[*].{Snapshot:DBSnapshotIdentifier,InstanceID:DBInstanceIdentifier,Status:Status}"

aws rds describe-db-snapshots --query "DBSnapshots[*].{Snapshot:DBSnapshotIdentifier,InstanceID:DBInstanceIdentifier,Status:Status}" --output yaml

aws rds describe-db-snapshots --query "DBSnapshots[*].{Snapshot:DBSnapshotIdentifier,InstanceID:DBInstanceIdentifier,Status:Status}" --output table

# Create read replica
aws rds create-db-instance-read-replica --db-instance-identifier 'qtrdsreplicafromcli' --source-db-instance-identifier 'qtrdsfromcli' --db-instance-class 'db.t2.micro' --publicly-accessible --no-multi-az --no-auto-minor-version-upgrade --vpc-security-group-ids "sg-075892da85bd09fc0"
aws rds describe-db-instances --query "DBInstances[*].{DBID: DBInstanceIdentifier, Status: DBInstanceStatus}" --output table

# promote read replica
aws rds promote-read-replica --db-instance-identifier 'qtrdsreplicafromcli'

aws rds delete-db-instance --db-instance-identifier 'qtrdsfromcli' --skip-final-snapshot 