#!/bin/bash

# basic info
aws s3 ls 

# human readable format
aws s3 ls --human-readable

aws s3 ls s3://qts3tbddocs --human-readable

# human readable format with summary
aws s3 ls s3://qts3tbddocs --human-readable --summarize

# remove buckets
aws s3 rb s3://qts3tbddocs

aws s3 rb s3://qts3tbddocs --force

# Create an s3 bucket with 3 folders
# images
# documents
# videos

aws s3 mb s3://qts3inclass

# Upload one object per folder from your local machine to s3 bucket
aws s3 cp ./contents/content.txt s3://qts3inclass/documents/content.txt

aws s3 cp ./contents/test.jpg s3://qts3inclass/images/test.jpg

aws s3 cp ./contents/one.mp4 s3://qts3inclass/videos/one.mp4

# Create a new bucket 
aws s3 mb s3://qts3inclasscopy

# syncronize the contents of one bucket to another
aws s3 sync s3://qts3inclass s3://qts3inclasscopy

# Summarize the contents 
aws s3 ls s3://qts3inclass --human-readable --summarize
aws s3 ls s3://qts3inclass --recursive --human-readable --summarize

aws s3 ls s3://qts3inclasscopy --human-readable --summarize
aws s3 ls s3://qts3inclasscopy --recursive --human-readable --summarize

# Delete the objects 
aws s3 rm --recursive s3://qts3inclasscopy

# Sync the contents from local machine to s3 bukcet
aws s3 sync ./contents s3://qts3inclass/contents

aws s3 ls s3://qts3inclass --recursive --human-readable








