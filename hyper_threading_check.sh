#!/bin/sh
#Linux HyperThreading check

nproc=$(grep -i "processor" /proc/cpuinfo | sort -u | wc -l)

phycore=$(cat /proc/cpuinfo | egrep "core id|physical id" | tr -d "\n" | sed s/physical/\\nphysical/g | grep -v ^$ | sort | uniq | wc -l)

if [ -z "$(echo "$phycore *2" | bc | grep $nproc)" ]

then

echo "HyperThreading is DISABLED"
echo "Number of logical processors: "
cat /proc/cpuinfo | grep Xeon | wc -l

else

   echo "HyperThreading is ENABLED" 
   echo "Number of logical processors: "
   cat /proc/cpuinfo | grep Xeon | wc -l
fi
