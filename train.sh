#!/bin/bash

set -x
set -e

# set CPU list
CPU_list=''
IFS=',' # hyphen (-) is set as delimiter
read -ra GPU <<< "${1}" # str is read into an array as tokens separated by IFS
IFS=' ' # reset to default value after usage
for i in "${GPU[@]}"; do # access each element of array
    cpu="$((${i}*8))-$((${i}*8+7))"
    if [ "$CPU_list" == '' ]
        then CPU_list=${cpu}
        else CPU_list="${CPU_list},${cpu}"
    fi
done

prefix="taskset -ac ${CPU_list}"
postfix="--gpu ${1} --save-path ./experiments/miniImageNet_MetaOptNet_SVM --train-shot 15 \
    --head SVM --network ResNet --dataset miniImageNet --eps 0.1"

$prefix python train.py $postfix
