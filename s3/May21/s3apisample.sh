#!/bin/bash

aws s3api create-bucket --acl 'public-read' --bucket 'qts3apidemo' --region 'us-east-1'

aws s3api put-object --bucket 'qts3apidemo' --key 'videos/one.mp4' --body './contents/one.mp4'

# Create the similar structure like what we have done with basic s3 commands