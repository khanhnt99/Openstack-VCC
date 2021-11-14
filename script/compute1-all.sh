#!/bin/bash

source function.sh
source config.sh

echocolor "IP address"
source com1-0-ipaddr.sh

echocolor "Environment"
source com1-1-environment.sh

echocolor "Nova"
source com1-2-nova.sh