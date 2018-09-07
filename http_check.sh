#!/bin/bash
#Simple HTTP check example

host='192.168.30.10' #set your ip or hostname
port='80' #set your http port
response=$(curl -Is http://$host:$port | head -1 | cut -d ' ' -f2)

echo -e "Checking HTTP for $host:$port..."
for i in {1..1000};do
    sleep 1
    if [[ $response -eq 200 ]]; then
        echo -e "$(date '+%H:%M:%S') - HTTP - $response - OK"
    else
        echo -e "$(date '+%H:%M:%S') - HTTP - $response - ERROR"
    fi
done
