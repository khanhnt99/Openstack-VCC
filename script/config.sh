#!/bin/bash

########################################
#### Set local variable for scripts ####
########################################

echocolor "Set local variable for scripts"
sleep 3

# IP addresses variable and hostnam variable
# Controller node
CTL_EXT_IF=ens4
CTL_MGNT_IP=10.10.10.2
CTL_MGNT_NETMASK=255.255.255.0
CTL_PREFIX_MGNT=24
CTL_MGNT_IF=ens3
CTL_WAN_IF=ens5

# Compute1 node
COM1_EXT_IF=ens4
COM1_MGNT_IP=10.10.10.3
COM1_MGNT_NETMASK=255.255.255.0
COM1_MGNT_IF=ens3
COM1_WAN_IF=ens5
# Compute2 node
COM2_EXT_IF=ens4
COM2_MGNT_IP=10.10.10.4
COM2_MGNT_NETMASK=255.255.255.0
COM2_MGNT_IF=ens3
COM2_WAN_IF=ens5

CIDR_MGNT=10.10.10.0/24

# Gateway External network
# Hostname variable
HOST_CTL=khanhnt-controller
HOST_COM1=khanhnt-compute-1
HOST_COM2=khanhnt-compute-2

DEFAULT_PASS="vccloud123"


ADMIN_PASS=$DEFAULT_PASS
DEMO_PASS=$DEFAULT_PASS
DOMAIN_ADMIN_PASS=$DEFAULT_PASS
RABBIT_PASS=$DEFAULT_PASS
KEYSTONE_DBPASS=$DEFAULT_PASS	
GLANCE_DBPASS=$DEFAULT_PASS	
GLANCE_PASS=$DEFAULT_PASS	
METADATA_SECRET=$DEFAULT_PASS	
NEUTRON_DBPASS=$DEFAULT_PASS	
NEUTRON_PASS=$DEFAULT_PASS	
NOVA_PASS=$DEFAULT_PASS	
NOVA_DBPASS=$DEFAULT_PASS
PLACEMENT_PASS=$DEFAULT_PASS
PLACEMENT_DBPASS=$DEFAULT_PASS