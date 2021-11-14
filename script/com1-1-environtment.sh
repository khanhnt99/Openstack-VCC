#!/bin/bash

source function.sh
source config.sh

# Function update and upgrade for COMPUTE
update_upgrade () {
	echocolor "Update and Upgrade COMPUTE"
	sleep 3
	apt update -y && apt upgrade -y
}

# Function install crudini
install_crudini () {
	echocolor "Install crudini"
	sleep 3
	apt install -y crudini
}

# Function install and config NTP
install_ntp () {
	echocolor "Install NTP"
	sleep 3

	apt install chrony -y
	ntpfile=/etc/chrony/chrony.conf

	sed -i 's|'"pool ntp.ubuntu.com        iburst maxsources 4"'| \
	'"server $CTL_MGNT_IP iburst"'|g' $ntpfile
	
	sed -i 's/pool 0.ubuntu.pool.ntp.org iburst maxsources 1//g' $ntpfile
	sed -i 's/pool 1.ubuntu.pool.ntp.org iburst maxsources 1//g' $ntpfile
	sed -i 's/pool 2.ubuntu.pool.ntp.org iburst maxsources 2//g' $ntpfile

	timedatectl set-timezone Asia/Ho_Chi_Minh

	service chrony restart
}

# Function install OpenStack packages (python-openstackclient)
install_ops_packages () {
	echocolor "Install OpenStack client"
	sleep 3
	apt install software-properties-common -y
	add-apt-repository cloud-archive:wallaby -y
	apt update -y 
}

#######################
###Execute functions###
#######################

# Update and upgrade for COMPUTE
update_upgrade

# Install crudini
install_crudini

# Install and config NTP
install_ntp

# OpenStack packages (python-openstackclient)
install_ops_packages