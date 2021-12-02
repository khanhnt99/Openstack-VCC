#!/bin/bash
# Author Nguyen Trong Tan
# Edit by khanhnt99
source function.sh
source config.sh

echocolor "IP address"
source com2-0-ipaddr.sh

echocolor "Environment"
source com2-1-environment.sh

echocolor "Nova"
source com2-2-nova.sh

echocolor "Neutron"
source com2-3-neutron.sh