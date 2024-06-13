#!/bin/bash
BUCKET_NAME=$1
aws s3api list-object-versions --bucket ${BUCKET_NAME} > /dev/null
aws s3api delete-objects --bucket ${BUCKET_NAME} --delete "$(aws s3api list-object-versions --bucket ${BUCKET_NAME} --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
aws s3api delete-objects --bucket ${BUCKET_NAME} --delete "$(aws s3api list-object-versions --bucket ${BUCKET_NAME} --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"
aws s3 rb s3://${BUCKET_NAME} --force