#!/bin/bash -ex 
# 
LOCAL_IP=`ifconfig ens3 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'` 
GAL_IP1=`grep controller-1 /etc/hosts | awk '{print $1}'` 
GAL_IP2=`grep controller-2 /etc/hosts | awk '{print $1}'` 
GAL_IP3=`grep controller-3 /etc/hosts | awk '{print $1}'`
############################################################
echo "Instal; Percona ExtraDB"
sleep 3

echo "Install repo"
wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
dpkg -i percona-release_latest.generic_all.deb

echo "Update repo"
apt-get update -y

echo "Enable percona version 57"
percona-release enable pxc-57 release

echo "Update repo"
apt-get update -y

echo "Install percona-xtradb-cluster-57"
apt install percona-xtradb-cluster-57 -y

mv /etc/mysql/percona-xtradb-cluster.conf.d/mysqld.conf /etc/mysql/percona-xtradb-cluster.conf.d/mysqld.conf.bak
mv /etc/mysql/percona-xtradb-cluster.conf.d/wsrep.conf /etc/mysql/percona-xtradb-cluster.conf.d/wsrep.conf.bak
cat << EOF > /etc/mysql/percona-xtradb-cluster.conf.d/mysqld.conf
# Config master-master percona mysql
[mysqld]
user = mysql
default-time-zone = '+7:00'
max_connections = 5000
slow-query-log = /var/log/mysql/mysql-slow.log
long_query_time = 2
innodb_lock_wait_timeout = 100
server-id=1
# datadir=/var/lib/percona-xtradb-cluster
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
log-bin
log_slave_updates
expire_logs_days=7

# UTF8
default_storage_engine = innodb
innodb_file_per_table = on 
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8

# Path to Galera library
wsrep_provider = /usr/lib/libgalera_smm.so

# Cluster connection URL contains IPs of node#1, node#2, node#3
wsrep_cluster_address = gcomm://$GAL_IP1,$GAL_IP2,$GAL_IP3

# In order for Galera to work correctly binlog format should be ROW
binlog_format = ROW

# MyISAM storage engine has only experimental support
default_storage_engine = InnoDB

# This changes how InnoDB autoincreament locks are managed and is a requirement for Galera
innodb_autoinc_lock_mode = 2

# Node #1 address
wsrep_node_address = $LOCAL_IP

# Cluster Name
wsrep_cluster_name = test_cluster

# SST method
wsrep_sst_method = xtrabackup-v2

# Authentication for SST method
wsrep_sst_auth = 'sstuser:123456'
# pxcstrict_mode allowed values: DISABLED, PERMISSVE, ENFORCING, MASTER
pxc_strict_mode=PERMISSIVE

# mysql server innodb config 
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_method = O_DIRECT

# Time out tuning
net_read_timeout = 500
net_write_timeout = 500
max_allowed_packet = 10000000000
slave_net_timeout = 3600
thread_pool_idle_timeout = 3600
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
EOF

