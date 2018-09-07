#!/bin/bash
# tcpdump automate script example
 
set -u
unitlist=$(cat unitlist)
timeout=$1

for i in $unitlist;
do echo -e "starting tcpdump for $i";
ssh $i 'if [[ $(version | grep HW_TYPE | awk "{print \$2}") == 'IBM' ]]; then
                {
                echo -e "mach IBM"
                if [[ $(ifconfig | grep bond1 | wc -l) == 1 ]]; then
                        {
                        screen -dmS dump tcpdump -U -i bond1 -vvv -nn -s0 src net 172.28.94.0/24 or dst net 172.28.94.0/24 -w /data/bond1_`hostname`_`date +%Y%m%d.cap`
                        }
                else
                        {
                        echo -e "No bonding! Using eth1"
                        screen -dmS dump tcpdump -U -i eth1 -vvv -nn -s0 src net 172.28.94.0/24 or dst net 172.28.94.0/24 -w /data/eth1_`hostname`_`date +%Y%m%d.cap`
                        }
                fi
                }
        elif [[ $(version | grep HW_TYPE | awk "{print \$2}") == 'ProLiant' || $(version | grep HW_TYPE | awk "{print \$3}") == 'ProLiant' ]]; then
                {
                echo -e "mach HP"
                screen -dmS dump tcpdump -U -i bond0.75 -vvv -nn -s0 src net 172.28.94.0/24 or dst net 172.28.94.0/24 -w /data/bond1_`hostname`_`date +%Y%m%d.cap`
                }
        else
                {
                echo -e "Unknown HW type, tcpdump was not started"
                }
        fi';
done

echo -e "waiting for $timeout seconds..."
sleep $timeout
echo -e ""

for i in $unitlist;
do echo -e "stopping tcpdump for $i";
ssh $i 'killall screen';
done

echo -e ""
echo -e "check ps and cap files on units"

for i in $unitlist;
do ssh $i 'ps -ef | egrep [t]cpdump; ls -ltr /data/*.cap';
done
