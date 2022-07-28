# Cấu hình Openstack High Availability

![](https://i.ibb.co/10v4VLj/Screenshot-from-2021-09-25-00-04-57.png)

### Địa chỉ IP:

|Host| IP| CPU|RAM|
|----|---|----|---|
|controller-1| 10.10.10.1 `VIP:10.10.10.4`|2|6GB|
|controller-2| 10.10.10.2 `VIP:10.10.10.4`|2|6GB|
|controller-3| 10.10.10.3 `VIP:10.10.10.4`|2|6GB|
|compute-1|10.10.10.5 `WAN: 203.1.0.0/24`|4|8GB|
|compute-2|10.10.10.6 `WAN: 203.1.0.0/24`|4|10GB|
|Linux-gateway|10.10.10.254 `NAT dải MGNT`|1|2GB|
|Router|203.1.0.1 `NAT WAN VM`|X|X| 

### Mục tiêu: Thực hiện High availability Openstack
- HA Mysql sử dụng Percona XtraDB cluster.
- HA rabbitMQ sử dụng Keepalive và HAProxy.

### Các bước thực hiện
- Cài đặt network, hostname, repository, update Ubuntu, ntp servers, /etc/host các node controller.
- Cấu hình HAProxy, Keepalive trên các node controller.
- Cấu hình percona XtraDB cho mysql trên các node controller.
- Cấu hình Keystone trên các node controller.
- Cấu hình Glance trên các node controller.
- Cấu hình Nova trên các node controller.
- Cấu hình neutron trên các node controller.
- Cấu hình nova-compute và neutron trên các compute node.

- Password sử dụng chung: 123456
- DHCP file
```
subnet 10.10.10.0 netmask 255.255.255.0 {
  range 10.10.10.1 10.10.10.253;
  option subnet-mask 255.255.255.0;
  option domain-name-servers 8.8.8.8;
  option routers 10.10.10.254;
  option broadcast-address 10.10.10.255;
  default-lease-time 600;
  max-lease-time 7200;
}

host controller-1 {
  hardware ethernet 50:19:00:01:00:00;
  fixed-address 10.10.10.1;
}

host controller-2 {
  hardware ethernet 50:19:00:02:00:00;
  fixed-address 10.10.10.2;
}

host controller-3 {
  hardware ethernet 50:19:00:03:00:00;
  fixed-address 10.10.10.3;
}

```

- iptables
  + `iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens4 -j MASQUERADE`

- Mô hình tương tự 
  + https://github.com/alfredcs/3-node-HA-OpenStack-Cluster-Installation

  ![](https://cloud.githubusercontent.com/assets/3374971/7358159/85d0749c-ece8-11e4-993e-4cef1ce01a49.png)

  |Service|Port|
  |-------|----|
  |`Keystone`| 5000|
  |`Glance`|9292|
  |`Placement`|8778|
  |`Nova`|8774|
  |`Neutron`|9696|
  |`RabbitMQ`|5672|
  
![](https://i.ibb.co/MMH6JgX/Screenshot-from-2021-09-25-10-12-51.png)

#### Thực hành
##### Controller
###### 1. Cấu hình prepare 
- `bash 0_prepare.sh`

###### 2. Cấu hình HAProxy-Keepalived
- `bash 1_haproxy_keepalive.sh`
- `net.ipv4.ip_nonlocal_bind = 1`
- `sysctl -p`

###### 3. Cấu hình Percona XtraDB Cluster
- `bash 2_xtradb.sh`

```
Node controller-1
/etc/init.d/mysql bootstrap-pxc
CREATE USER 'sstuser'@'localhost' IDENTIFIED BY '123456';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'sstuser'@'localhost';`
FLUSH PRIVILEGES;

Other controler-node
service mysql restart
```

###### 4. Cấu hình RabbitMQ cluster
- Docs: https://docs.huihoo.com/openstack/docs.openstack.org/ha-guide/shared-messaging.html
- `apt-get install rabbitmq-server –y `
- `service rabbitmq-server stop`
- `cp /var/lib/rabbitmq/.erlang.cookie` từ node controller-1 sang các node controller-2 và controller-3.
- `chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie`
- `chmod 400 /var/lib/rabbitmq/.erlang.cookie`
- Khởi động lại rabbitmq trên cả 3 node rồi kiểm tra trạng thái
  + `rabbitmq clutser_status`
- Trên node controller-2 và controller-3 lần lượt stop dịch vụ, join cluster và khởi động lại.
  + `rabbitmqctl stop_app`
  + `rabbitmqctl join_cluster --ram rabbit@controller-1`
  + `rabbitmqctl start_app`
- `rabbitmqctl cluster_status`
- Thực hiện gán quyền cho user openstack trên controller-1
  - `rabbitmqctl add_user openstack 123456`
  - `rabbitmqctl set_permissions openstack ".*" ".*" ".*" `
- Kiểm tra trên controller-2 và controller-3
  - `rabbitmqctl list_users`
  - `rabbitmqctl list_permissions`
- Trên controller-1
  - `rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}' `

###### 5. Cài đặt các controller services trên 3 node controller-1, controller-2, controller-3


__Docs__
- https://github.com/vietstacker/openstack-HA
- https://docs.openstack.org/wallaby/
- https://github.com/alfredcs/3-node-HA-OpenStack-Cluster-Installation
- https://docs.huihoo.com/openstack/docs.openstack.org/ha-guide/shared-messaging.html

