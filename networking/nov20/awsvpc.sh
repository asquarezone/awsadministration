#!/bin/bash

# Creating a vpc with aws cli
 aws ec2 create-vpc --cidr-block '10.100.0.0/16' --tag-specifications 'ResourceType=vpc,Tags=[{Key="Name",Value="ntier"}]'