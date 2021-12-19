aws s3 ls

# create a bucket 
aws s3 mb s3://qts3bucketfromcli

# create a bucket for replication in other regions
aws s3 mb s3://qts3bucketfromclireplica --region 'us-east-1'

# enable bucket versioning
aws s3api put-bucket-versioning --bucket 'qts3bucketfromcli' `
    --versioning-configuration 'Status=Enabled'

aws s3api put-bucket-versioning --bucket 'qts3bucketfromclireplica' `
    --versioning-configuration 'Status=Enabled'

aws s3api put-bucket-replication `
    --replication-configuration file://replication.json `
    --bucket 'qts3bucketfromcli'

# Now lets copy some content from your system into s3 bucket
aws s3 cp --recursive 'D:\khajaclassroom\aws\administration\s3\Nov21\htmlpages' 's3://qts3bucketfromcli'

aws s3 ls 's3://qts3bucketfromcli'

aws s3 ls 's3://qts3bucketfromclireplica'

# changing one objects storage class
aws s3 cp `
"D:\khajaclassroom\aws\administration\s3\Nov21\htmlpages\indexwithcloudfront.html" `
's3://qts3bucketfromcli' `
--storage-class 'ONEZONE_IA'

# Enabling public access to an object

aws s3api put-object-acl --acl 'public-read' --bucket 'qts3bucketfromcli' --key 'indexwithcloudfront.html'