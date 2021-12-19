#!/bin/bash
aws s3 ls

# create a bucket 
aws s3 mb s3://qts3bucketfromcli

# create a bucket for replication in other regions
aws s3 mb s3://qts3bucketfromclireplica --region 'us-east-1'

# enable bucket versioning
aws s3api put-bucket-versioning --bucket 'qts3bucketfromcli' \
    --versioning-configuration 'Status=Enabled'

aws s3api put-bucket-versioning --bucket 'qts3bucketfromclireplica' \
    --versioning-configuration 'Status=Enabled'

aws s3api put-bucket-replication \
    --replication-configuration file://replication.json \
    --bucket 'qts3bucketfromcli'