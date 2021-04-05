## **Keystone**
```
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'corgi1208';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'corgi1208';
```

```
keystone-manage bootstrap --bootstrap-password corgi1208 \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
```

```
export OS_USERNAME=admin
export OS_PASSWORD=corgi1208
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
```

## **Glance**
```
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'corgi1208';
```

## **Placement**
```
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' \
  IDENTIFIED BY 'corgi1208';
```

## **Nova**
- **controller**
```
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'corgi1208';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'corgi1208';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'corgi1208';
```

- **compute**

## **Neutron**
- **controller**
```
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
  IDENTIFIED BY 'corgi1208';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
  IDENTIFIED BY 'corgi1208';
```
## Launch Instance
```
openstack subnet create --network selfservice \
  --dns-nameserver 8.8.4.4 --gateway 192.168.10.1 \
  --subnet-range 192.168.10.0/24 selfservice
```
```
root@controller:~# openstack subnet create --network selfservice \
>   --dns-nameserver 8.8.4.4 --gateway 192.168.10.1 \
>   --subnet-range 192.168.10.0/24 selfservice
+-------------------+--------------------------------------+
| Field             | Value                                |
+-------------------+--------------------------------------+
| allocation_pools  | 192.168.10.2-192.168.10.254          |
| cidr              | 192.168.10.0/24                      |
| created_at        | 2021-03-30T16:38:26Z                 |
| description       |                                      |
| dns_nameservers   | 8.8.4.4                              |
| enable_dhcp       | True                                 |
| gateway_ip        | 192.168.10.1                         |
| host_routes       |                                      |
| id                | 41cdb3ee-57cb-47bf-b992-aa60cc4acf88 |
| ip_version        | 4                                    |
| ipv6_address_mode | None                                 |
| ipv6_ra_mode      | None                                 |
| name              | selfservice                          |
| network_id        | 1f04cbcb-16fb-41b8-adb4-b45ab51653cf |
| project_id        | bad9fbf8fe9c4537946a8bca2e0685af     |
| revision_number   | 0                                    |
| segment_id        | None                                 |
| service_types     |                                      |
| subnetpool_id     | None                                 |
| tags              |                                      |
| updated_at        | 2021-03-30T16:38:26Z                 |
+-------------------+--------------------------------------+
```

```
openstack server create --flavor m1.nano --image cirros \
  --nic net-id=1f04cbcb-16fb-41b8-adb4-b45ab51653cf --security-group default \
  --key-name mykey selfservice-instance
```