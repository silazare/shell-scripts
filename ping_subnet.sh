#!/bin/bash

ip="1"
ip_end="255"
ping_ip=""
network="172.17.200"

if [ $1 ]
then
  net=$1;
  if [ `echo $net | grep [^0-9.]` ]
  then
    echo -ne "Bad address \"$net\"!\n";
    exit;
  fi
  if [ -z `echo $1 | awk -F. 'END {print $NF}'` ]
  then
    net=`expr $net : '\(.*\)\.'`;
  fi
  l=`echo $net | awk -F. 'END {print NF}'`;
  if [ $l -eq 4 ]
  then
    network=`expr $net : '\(.*\)\.'`;
    ip=`expr $net : '.*\.\(.*\)' \| 1`;
  elif [ $l -eq 3 ]
  then
    network=$net;
  else
    echo -ne "Bad argument \"$net\"!\n";
    exit;
  fi
fi

while [ $ip -le $ip_end ]
do
	ping_ip="$network.$ip";
	if [ `ping $ping_ip -W 1 -c 1 | grep received | awk '{print $4}'` -ne "0" ]
	then
		echo -ne "ping from $ping_ip\n";
	else
		echo -ne "No ping from $ping_ip\n";
	fi
	ip=`expr $ip + 1`;
done