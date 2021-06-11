- Cấu hình trong file `/etc/neutron/plugins/ml2/ml2_conf.ini`
```
[ml2_type_vlan]
network_vlan_ranges = provider
```

- Mỗi network tương ứng với một segment (segment ở đây gắn liền với VLAN ID)

```
root@compute1:~# ovs-ofctl dump-flows br-provider
 cookie=0x1e886772f8abe847, duration=796.264s, table=0, n_packets=130, n_bytes=11443, priority=4,in_port="phy-br-provider",dl_vlan=2 actions=mod_vlan_vid:204,NORMAL
 cookie=0x1e886772f8abe847, duration=347.885s, table=0, n_packets=123, n_bytes=10925, priority=4,in_port="phy-br-provider",dl_vlan=3 actions=mod_vlan_vid:205,NORMAL
 cookie=0x1e886772f8abe847, duration=13760.950s, table=0, n_packets=10, n_bytes=852, priority=2,in_port="phy-br-provider" actions=drop
 cookie=0x1e886772f8abe847, duration=13760.958s, table=0, n_packets=12643, n_bytes=891676, priority=0 actions=NORMAL
```

```
root@controller:~# . adminrc 
root@controller:~# openstack network create --share --provider-physical-network provider --provider-network-type vlan --provider-segment 205 provider-205
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | UP                                   |
| availability_zone_hints   |                                      |
| availability_zones        |                                      |
| created_at                | 2021-06-11T11:26:01Z                 |
| description               |                                      |
| dns_domain                | None                                 |
| id                        | 9b60a476-e736-4caa-8b44-2b1193ea5d84 |
| ipv4_address_scope        | None                                 |
| ipv6_address_scope        | None                                 |
| is_default                | False                                |
| is_vlan_transparent       | None                                 |
| mtu                       | 1500                                 |
| name                      | provider-205                         |
| port_security_enabled     | True                                 |
| project_id                | fd75f3b6df4a4fe68162874b60a6e04b     |
| provider:network_type     | vlan                                 |
| provider:physical_network | provider                             |
| provider:segmentation_id  | 205                                  |
| qos_policy_id             | None                                 |
| revision_number           | 1                                    |
| router:external           | Internal                             |
| segments                  | None                                 |
| shared                    | True                                 |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tags                      |                                      |
| updated_at                | 2021-06-11T11:26:01Z                 |
+---------------------------+--------------------------------------+
root@controller:~# openstack subnet create --network provider-205 --allocation-pool start=205.0.0.10,end=205.0.0.250 --dns-nameserver 8.8.4.4 --gateway 205.0.0.1 --subnet-range 205.0.0.0/24 provider-v4-205
+----------------------+--------------------------------------+
| Field                | Value                                |
+----------------------+--------------------------------------+
| allocation_pools     | 205.0.0.10-205.0.0.250               |
| cidr                 | 205.0.0.0/24                         |
| created_at           | 2021-06-11T11:26:48Z                 |
| description          |                                      |
| dns_nameservers      | 8.8.4.4                              |
| dns_publish_fixed_ip | None                                 |
| enable_dhcp          | True                                 |
| gateway_ip           | 205.0.0.1                            |
| host_routes          |                                      |
| id                   | ce3279d9-8938-4214-8f5b-92954fd39fc5 |
| ip_version           | 4                                    |
| ipv6_address_mode    | None                                 |
| ipv6_ra_mode         | None                                 |
| name                 | provider-v4-205                      |
```

