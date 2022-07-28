#!/bin/bash -ex  
echo "### Configure hosts file ###" 
cat << EOF > /etc/hosts 
127.0.0.1 localhost
10.10.10.1 controller-1 
10.10.10.2 controller-2
10.10.10.3 controller-3
EOF

echo "#### Update for Ubuntu #####"
apt-get install software-properties-common -y
add-apt-repository cloud-archive:wallaby -y

sleep 3
echo "##### update for Ubuntu #####" 
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y 

echo "Install python client" 
apt install python3-openstackclient -y
sleep 5 

echo "Install and config NTP" 
sleep 3 
apt install chrony -y

## Config NTP in Train
sed -i 's/pool 2.debian.pool.ntp.org offline iburst/ \
pool 2.debian.pool.ntp.org offline iburst \
server 0.asia.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst/g' /etc/chrony/chrony.conf

service chrony restart

echo "Reboot Server"
#sleep 5
init 6
