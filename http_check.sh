#!/bin/bash
#Simple web services check
#For HTTPS force to use no certificate validation as purpose here just to check basic host availability
#Port parsing also captured tails, so more complex or long URLs should be fine
set -e

#input variables section
if [[ $(echo "$1" | awk -F '://' '{print $0}' | grep http | wc -l | xargs) == 1 ]]; then
    protocol=$(echo "$1" | awk -F ':' '{print $1}')
    host=$(echo "$1" | awk -F ':' '{print $2}' | cut -d '/' -f3)
    port=$(echo "$1" | awk -F ':' '{print $3}')
else
    echo -e "Protocol is unset, using HTTP"
    protocol='http'
    host=$(echo "$1" | awk -F ':' '{print $1}' | cut -d '/' -f3)
    port=$(echo "$1" | awk -F ':' '{print $2}')
fi

cycles=$2

#check if input variable was passed
if [[ $# -eq 0 ]]; then
    echo -e "`basename $0`: Missing parameters"
    echo -e "Usage: ./`basename $0` <URL> <number of cycles>"
    echo -e "Example: ./`basename $0` http://192.168.1.1:80 10"
    echo -e "Default http port - 80, https - 443"
    echo -e "Default number of cycles - 10"
    exit 1
fi

#check cycles
if [[ -z $cycles ]]; then
    echo -e "Number of cycles is unset, using default value"
    cycles=10
fi

#check port
if [[ -z $port ]]; then
    echo -e "Port is unset, using default value"
    if [[ $protocol == 'http' ]]; then
        port=80
        echo -e "http port: $port"
    elif [[ $protocol == 'https' ]]; then
        port=443
        echo -e "https port: $port"
    else
        echo -e "Wrong protocol!"
        exit 1
    fi
fi

#main section
if [[ $protocol == 'http' ]]; then
    response=$(curl -Is $protocol://$host:$port| head -1 | cut -d ' ' -f2)
    echo -e "Checking HTTP for $protocol://$host:$port"
    echo -e ""
    i=1
    while [[ "$i" -le "$cycles" ]]; do
        sleep 1
        if [[ -z $response ]]; then
            response=$(curl --silent --show-error --fail $protocol://$host:$port)
            exit 1
        elif [[ $response -lt 399 ]]; then
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - OK"
        else
            echo -e "$(date '+%H:%M:%S') - HTTP - $response - ERROR"
        fi
        i=$(($i + 1))
    done
elif [[ $protocol == 'https' ]]; then
    response=$(curl -Iks $protocol://$host:$port | head -1 | cut -d ' ' -f2)
    echo -e "Checking HTTPS for $protocol://$host:$port"
    echo -e ""
    i=1
    while [[ "$i" -le "$cycles" ]]; do
        sleep 1
        if [[ -z $response ]]; then
            response=$(curl --silent --show-error --fail $protocol://$host:$port)
            exit 1
        elif [[ $response -lt 399 ]]; then
            echo -e "$(date '+%H:%M:%S') - HTTPS - $response - OK"
        else
            echo -e "$(date '+%H:%M:%S') - HTTPS - $response - ERROR"
        fi
        i=$(($i + 1))
    done
else
    echo -e "Wrong protocol!"
    exit 1;
fi
