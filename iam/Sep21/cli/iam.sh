#!/bin/bash
# Create a user ironman
aws iam create-user --user-name ironman
aws iam create-user --user-name thor
aws iam create-group --group-name dbadmins