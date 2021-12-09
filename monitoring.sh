#!/usr/bin/bash

architecture=$(uname -a)
physical_processor=$(grep 'cpu cores' /proc/cpuinfo | tr -d 'cpu cores \t:')
virtual_processor=$(grep -c '^processor' /proc/cpuinfo)
total_memory=$(free -m | awk '/Mem:/ {print $2}')
used_memory=$(free -m | awk '/Mem:/ {print $3}')
percent_used_memory=$(free -m | awk '/Mem:/ {printf "%.2f", $3/$2*100}')
total_disk=$(df -Bg --total | awk '/total/ {printf "%dGB", $2}')
used_disk=$(df -Bm --total | awk '/total/ {printf "%d", $3}')
percent_used_disk=$(df --total | awk '/total/ {printf "(%s)", $5}')
cpu_load=$(top -bn1 | awk '/Cpu/ {printf "%.1f%%", $2}')
last_boot=$(who -b | awk '{print $3" "$4}')
total_lvm=$(lsblk | grep -c lvm)
if [ $total_lvm -gt 0 ]; then lvm='yes'; else lvm='no'; fi
tcp_connections=$(netstat -st | awk '/established/ {print $1}')
total_users=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip a | awk '/link\/ether/ {print $2}')
sudo_total=$(grep -c "COMMAND" /var/log/sudo/sudo.log)

echo "#Architecture: $architecture"
echo "#CPU physical : $physical_processor"
echo "#vCPU : $virtual_processor"
echo "#Memory Usage: $used_memory/${total_memory}MB (${percent_used_memory}%)"
echo "#Disk Usage: $used_disk/${total_disk} ${percent_used_disk}"
echo "#CPU load: $cpu_load"
echo "#Last boot: $last_boot"
echo "#LVM use: $lvm"
echo "#Connections TCP : $tcp_connections ESTABLISHED"
echo "#User log: $total_users"
echo "#Network: IP $ip ($mac)"
echo "#Sudo : $sudo_total cmd"
