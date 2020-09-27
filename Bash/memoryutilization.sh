#!/bin/bash
memuti() {
echo "Time= `date`"
sysmonitor() {
        
        INPUT=$(ps -eo pid,user,%mem,%cpu,command ax --sort=-%mem | grep -v PID| head | awk '/[0-9]*/{print $1 ":" $2 ":" $3 ":" $4 ":" $5}')
        for i in $INPUT
        do
           PID=$(echo $i | cut -d: -f1)
           OWNER=$(echo $i | cut -d: -f2)
           MEMORY=$(echo $i | cut -d: -f3)
           CPU=$(echo $i | cut -d: -f4)
           COMMAND=$(echo $i | cut -d: -f5)

           printf "%-10s%-15s%-15s%-15s%s\n" "$PID" "$OWNER" "$MEMORY" "$CPU" "$COMMAND"
        done
}

sysmonitor | sort -bnr -k3 | head -15
echo ""
}
header=`cat /home/centos/memtest/memoryutilization_$(date +%Y-%m-%d).csv 2> /dev/nul | grep PID | uniq | awk {'print $2'} `
if  [[ -z $header ]]
then
printf "%-10s%-15s%-15s%-15s%s\n" "PID" "OWNER" "MEMORY" "CPU" "COMMAND" >> /home/centos/memtest/memoryutilization_$(date +%Y-%m-%d).csv
fi
memuti >> /home/centos/memtest/memoryutilization_$(date +%Y-%m-%d).csv

