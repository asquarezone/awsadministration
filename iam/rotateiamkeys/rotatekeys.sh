#!/bin/bash

### usage is get_access_key username
get_access_key() {
    access_key=$(aws iam list-access-keys --user-name $user --query "AccessKeyMetadata[0].AccessKeyId"|tr -d '"')
    echo $access_key

}

send_email() {
    echo "Sending email with json attached"
}

#users=$(aws iam list-users --query "Users[].UserName")
users=(testuser1 testuser2)
for user in ${users[@]}; do
  echo "rotating credentials for $user"
  current_access_key=$(get_access_key $user)
  aws iam create-access-key --user-name $user > $user.json
  send_email
  echo "deleting current access key $current_access_key"
  aws iam delete-access-key --access-key-id $current_access_key --user-name $user
  new_access_key=$(get_access_key $user)
  echo "New access key is $new_access_key"
done