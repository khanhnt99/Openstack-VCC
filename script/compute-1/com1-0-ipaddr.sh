#!/bin/bash
# Author Nguyen Trong Tan
# Edit by khanhnt99

source function.sh
source config.sh

# Function config COMPUTE node
config_hostname () {
	echo "$HOST_COM1" > /etc/hostname
	hostnamectl set-hostname $HOST_COM1

	cat << EOF >/etc/hosts
127.0.0.1	localhost
$CTL_MGNT_IP	$HOST_CTL
$COM1_MGNT_IP	$HOST_COM1	
$COM2_MGNT_IP	$HOST_COM2	
EOF
}

# Function IP address
config_ip () {
    cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ${COM1_EXT_IF}:
      dhcp4: no
    ${COM1_MGNT_IF}:
      dhcp4: no
      addresses: [${COM1_MGNT_IP}/${COM1_PREFIX_MGNT}]
    ${COM1_WAN_IF}:
      dhcp4: yes
EOF
	netplan apply
}

#######################
###Execute functions###
#######################

# Config COMPUTE node
echocolor "Config COMPUTE node"
sleep 3
## Config hostname
config_hostname

## IP address
config_ip