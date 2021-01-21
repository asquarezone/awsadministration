#!/bin/bash
# query using aws cli to fetch database instance identifiers
aws rds describe-db-instances --query "DBInstances[*].DBInstanceIdentifier"

#  to fetch database instance id and masterusername 
aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier, MasterUsername]"

aws rds describe-db-instances --query "DBInstances[*].{ID: DBInstanceIdentifier, Username:MasterUsername}"

aws rds describe-db-instances --query "DBInstances[*].{ID: DBInstanceIdentifier, Username:MasterUsername}" --output table 

aws rds describe-db-instances --query "DBInstances[*].{ID: DBInstanceIdentifier, Username:MasterUsername}" --output text 

aws rds describe-db-instances --query "DBInstances[*].{ID: DBInstanceIdentifier, Username:MasterUsername}" --output yaml

# to fetch endpoint address for all mysql database instances
aws rds describe-db-instances --query "DBInstances[?Engine=='mysql'].Endpoint.Address"

#to fetch all the database snapshot identifiers and Status
aws rds describe-db-snapshots --query "DBSnapshots[*].{Id: DBSnapshotIdentifier, DBId: DBInstanceIdentifier, Status: Status}"
aws rds describe-db-snapshots --query "DBSnapshots[*].{Id: DBSnapshotIdentifier, DBId: DBInstanceIdentifier, Status: Status}" --output table

# to fetch all the database snapshot identifiers and Snapshot Creation time for mysql engine
aws rds describe-db-snapshots --query "DBSnapshots[?Engine=='mysql'].{Id: DBSnapshotIdentifier, DBId: DBInstanceIdentifier, CreationTime: SnapshotCreateTime}"


# to fetch all the db subnet group names other than default
aws rds describe-db-subnet-groups --query "DBSubnetGroups[?DBSubnetGroupName != 'default'].DBSubnetGroupName"



