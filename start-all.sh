#!/bin/bash

echo "Start all nodes"

data=$(ls -d /home/corda/nodes/*/ | sed 's/\/$//')

IFS=$'\n' read -r -d '' -a node_names <<< "$data"$'\n'

for node in "${node_names[@]}"; do
    cd "$node" || exit
    java -jar corda.jar &
done