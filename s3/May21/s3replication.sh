#!/bin/bash

# Create a bucket in us-east-1
aws s3 mb --region us-west-2 s3://qts3fromcliorig

# Create a bucket in different region
aws s3 mb --region us-west-1 s3://qts3fromclicopy

# Lets enable versioning
aws s3api put-bucket-versioning --bucket qts3fromcliorig --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket qts3fromclicopy --versioning-configuration Status=Enabled

# Create a  role to allow copy of the s3 bucket objects
# Attach the policy to role
# Enable put-bucket replication