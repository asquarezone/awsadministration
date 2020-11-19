#!/bin/bash
aws iam create-group --group-name 'justiceleague'
for name in superman batman aquaman wonderwomen
do
    aws iam create-user --user-name $name
    aws iam create-login-profile --user-name $name --password-reset-required --password 'india@123'
    aws iam add-user-to-group --group-name 'justiceleague' --user-name $name
done

