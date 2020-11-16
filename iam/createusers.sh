#!/bin/bash
aws iam create-group --group-name 'avengers'
for name in Ironman Gamora BlackPanther CaptianAmerica Thor Hulk BlackWidow groot nebula spiderman
do
    aws iam create-user --user-name $name
    aws iam create-login-profile --user-name $name --password-reset-required --password 'india@123'
    aws iam add-user-to-group --group-name 'avengers' --user-name $name
done

