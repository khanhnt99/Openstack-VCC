#!/bin/bash

source function.sh
source config.sh

# Function config hostname
config_hostname () {
    echo "$HOST_CTL" > /etc/hostname
    hostnamectl set-hostname $HOST_CTL

    cat << EOF > /etc/hosts
127.0.0.1 localhost

$CTL_MGNT_IP    $HOST_CTL
$COM1_MGNT_IP   $HOST_COM1
$COM2_MGNT_IP   $HOST_COM2
EOF
}

config_ip () {
    cat << EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ${CTL_EXT_IF}:
      dhcp4: no
    ${CTL_MGNT_IF}:
      dhcp4: no
      addresses: [${CTL_MGNT_IP}/${CTL_PREFIX_MGNT}]
    ${CTL_WAN_IF}:
      dhcp4: yes
EOF
	netplan apply
}


# Config controller node
echocolor "Config Controller node"
sleep 3

## Config hostname
config_hostname

## Config ip address
config_ip

