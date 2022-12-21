#!/bin/bash
# to assign a default value if the value is empty
function_return_value=""
function assign_default_value {
    function_return_value=""
    value=$1
    default_value=$2
    echo "value is $value"
    if [[ -z "$value" ]]; then
        echo "value is empty"
        function_return_value=$default_value
    else
        echo "value is not empty"
        function_return_value=$value
    fi
}

test="1"

assign_default_value $region "us-west-2"
echo $function_return_value
assign_default_value $test "us-west-2"
echo $function_return_value