#!/bin/bash

# In this we will try to create ec2 instance
aws ec2 run-instances --image-id "ami-0a4a70bd98c6d6441" --instance-type "t2.micro" --key-name "climumbai" --security-group-ids "sg-09856719dfb1ab869"

# To Remove ec2 instance make a note of instance id
aws ec2 terminate-instances --instance-ids i-0bd538d74168d4e42