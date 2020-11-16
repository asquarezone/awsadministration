#!/bin/bash
for name in Ironman Gamora BlackPanther CaptianAmerica Thor Hulk BlackWidow groot nebula spiderman
do
    aws iam create-user --user-name $name
    aws iam create-login-profile --user-name $name --password-reset-required --password 'india@123'
done