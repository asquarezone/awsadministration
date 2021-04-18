#!/bin/bash
#users=$(aws iam list-users --query "Users[].UserName")
users=(testuser1 testuser2)
for user in ${users[@]}; do
  echo "rotating credentials for $user"
  current_access_key=$(aws iam list-access-keys --user-name $user --query "AccessKeyMetadata[0].AccessKeyId")
  current_access_key=$(echo $current_access_key | tr -d '"')
  aws iam create-access-key --user-name $user > $user.json
  # send email to admins or send json to users
  echo "deleting current access key $current_access_key"
  aws iam delete-access-key --access-key-id $current_access_key --user-name $user
  new_access_key=$(aws iam list-access-keys --user-name $user --query "AccessKeyMetadata[0].AccessKeyId"|tr -d '"')
  echo "New access key is $new_access_key"
done