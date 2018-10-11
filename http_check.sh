#!/bin/bash
#Simple web services check
set -e

#input variables section
host=$1 #set your ip or hostname
protocol=$2 #set http or https
port=$3 #set your port for http

if [[ $# -eq 0 ]]; then   
    echo -e "`basename $0`: Missing parameters"
    echo -e "Usage: ./`basename $0` hostname protocol port"
    echo -e "Example: ./`basename $0` 192.168.1.1 http 80"
    exit 1
fi

#main section
if [[ $protocol == 'http' ]]; then
    response=$(curl -Is $protocol://$host:$port | head -1 | cut -d ' ' -f2)
    echo -e "Checking HTTP for $protocol://$host:$port"
    echo -e ""
    for i in {1..1000};do
        sleep 1
        if [[ $response -lt 399 ]]; then
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - OK"
        else
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - ERROR"
        fi
    done
elif [[ $protocol == 'https' ]]; then
    response=$(curl -Is $protocol://$host | head -1 | cut -d ' ' -f2)
    echo -e "Checking HTTPS for $protocol://$host"
    echo -e ""
    for i in {1..1000};do
        sleep 1
        if [[ $response -lt 399 ]]; then
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - OK"
        else
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - ERROR"
        fi
    done
fi
