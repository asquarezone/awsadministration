aws s3 ls

# create a bucket 
aws s3 mb s3://qts3bucketfromcli

# create a bucket for replication in other regions
aws s3 mb s3://qts3bucketfromclireplica --region 'us-east-1'