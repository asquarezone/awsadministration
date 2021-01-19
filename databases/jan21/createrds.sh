#!/bin/bash

# This file will contain simple commands that can be executed to create rds
# instances and configuring them
aws rds create-db-instance --db-instance-identifier 'qtrdsfromcli' --allocated-storage 20 --db-instance-class 'db.t2.micro' --engine 'mysql' --master-username 'admin' --master-user-password 'admin1234' --vpc-security-group-ids "sg-075892da85bd09fc0" --backup-retention-period 7 --port 3306 --no-multi-az --no-auto-minor-version-upgrade 