#!/bin/bash

echo "Running DB migration"

data=$(ls -d /home/corda/nodes/*/ | sed 's/\/$//')

IFS=$'\n' read -r -d '' -a node_names <<< "$data"$'\n'

for node in "${node_names[@]}"; do
    cd "$node" || exit
    java -jar corda.jar run-migration-scripts --core-schemas --app-schemas --allow-hibernate-to-manage-app-schema
done

echo "DB migration completed"