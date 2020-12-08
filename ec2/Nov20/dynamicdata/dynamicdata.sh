#!/bin/bash

# IMDSv2
# Get the Token
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

# Get the AMI id of this instance
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/ami-id

### Version 1
# Get public ip address
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

### Version 2
public_ip=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

# Get AMI Id

## Version 1
ami-id=$(curl http://169.254.169.254/latest/meta-data/ami-id)

### Version2 
ami-id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/ami-id)

### Get VPC-id
### Version 1
vpc-id=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:fa:6a:3b:76:e0/vpc-id)

### Version2
vpc-id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:fa:6a:3b:76:e0/vpc-id)

### Get Subnet-id
### Version 1
subnet-id=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:fa:6a:3b:76:e0/subnet-id)

### Version
subnet-id=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/network/interfaces/macs/02:fa:6a:3b:76:e0/subnet-id)