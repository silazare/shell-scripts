#!/bin/bash

OK=$(echo -e "\e[42mUP\e[49m") # Green
PROBLEM=$(echo -e "\e[41mDOWN\e[49m") #Red

for host in $(cat /etc/hosts| grep $1 | grep -v admin| awk '{print $2}')
do
count=$( ping -c 1 $host | grep -c rtt )
if [ $count -eq 0 ]
then
    echo "$host is $PROBLEM"
else
    echo "$host is $OK"
fi
done