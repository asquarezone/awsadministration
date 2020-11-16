#!/bin/bash
for name in BlackPanther CaptianAmerica Thor Hulk BlackWidow groot nebula spiderman
do
    aws iam create-user --user-name $name
done