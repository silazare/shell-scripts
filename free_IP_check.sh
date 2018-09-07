#!/bin/bash

USE=$(echo -e "\e[42mUSE\e[49m") # Green
FREE=$(echo -e "\e[41mFREE\e[49m") #Red
NET="172.26.41"

for ip in {0..255}
do
count=$( ping -c 1 $NET.$ip | grep -c rtt )
if [ $count -eq 0 ]
then
    echo "$NET.$ip is $FREE"
else
    echo "$NET.$ip is $USE"
fi
done
