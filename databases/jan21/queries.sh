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



