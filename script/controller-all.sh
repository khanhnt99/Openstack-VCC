#!/bin/bash

source function.sh
source config.sh

echocolor "IP address"
source ctl-0-ipaddr.sh

echocolor "Environment"
source ctl-1-environment.sh

echocolor "Keystone"
source ctl-2-keystone.sh

echocolor "Glance"
source ctl-3-glance.sh

echocolor "Placement"
source ctl-4-placement.sh

echocolor "Nova"
source ctl-5-nova.sh