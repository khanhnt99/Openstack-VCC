# Cấu hình Nexus 
- Cấu hình interface

```
switch(config)# int e1/2
switch(config-if)# no switchport 
switch(config-if)# ip address 203.0.0.1/24
switch(config-if)# 
```

```
switch(config)# int e1/2
switch(config-if)# ip route 0.0.0.0/0 203.0.0.2 
switch(config)# end
switch# 
switch# show ip route
IP Route Table for VRF "default"
'*' denotes best ucast next-hop
'**' denotes best mcast next-hop
'[x/y]' denotes [preference/metric]
'%<string>' in via output denotes VRF <string>

0.0.0.0/0, ubest/mbest: 1/0
    *via 203.0.0.2, [1/0], 00:00:04, static
203.0.0.0/24, ubest/mbest: 1/0, attached
    *via 203.0.0.1, Eth1/2, [0/0], 00:02:28, direct
203.0.0.1/32, ubest/mbest: 1/0, attached
    *via 203.0.0.1, Eth1/2, [0/0], 00:02:28, local
```

```
switch(config)# feature interface-vlan 
switch(config)# interface vlan 204
switch(config-if)# ip add 204.0.0.1/24
switch(config-if)# interface vlan 205
switch(config-if)# ip add 205.0.0.1/24
```

```
switch(config)# int e1/1
switch(config-if)# switchport mode trunk
switch(config-if)# switchport trunk allowed vlan 204,205
switch(config-if)# no shut
```

```
switch(config)# vlan 204
switch(config-vlan)# vlan 205
```

```
switch(config-if)# int vlan 205
switch(config-if)# no shut
switch(config-if)# show int vlan 204
Vlan204 is up, line protocol is up, autostate enabled
  Hardware is EtherSVI, address is  5002.0002.0007
  Internet Address is 204.0.0.1/24
  MTU 1500 bytes, BW 1000000 Kbit, DLY 10 usec,
   reliability 255/255, txload 1/255, rxload 1/255
  Encapsulation ARPA, loopback not set
  Keepalive not supported
  ARP type: ARPA
  Last clearing of "show interface" counters never
  L3 in Switched:
    ucast: 0 pkts, 0 bytes

switch(config-if)# show int vlan 205
Vlan205 is up, line protocol is up, autostate enabled
  Hardware is EtherSVI, address is  5002.0002.0007
  Internet Address is 205.0.0.1/24
  MTU 1500 bytes, BW 1000000 Kbit, DLY 10 usec,
   reliability 255/255, txload 1/255, rxload 1/255
  Encapsulation ARPA, loopback not set
  Keepalive not supported
  ARP type: ARPA
  Last clearing of "show interface" counters never
  L3 in Switched:
    ucast: 0 pkts, 0 bytes
```

```
root@gw-trunking:~# ip r
default via 192.168.53.1 dev ens4 
192.168.53.0/24 dev ens4  proto kernel  scope link  src 192.168.53.136 
203.0.0.0/24 dev ens3  proto kernel  scope link  src 203.0.0.2 
204.0.0.0/24 via 203.0.0.1 dev ens3 
205.0.0.0/24 via 203.0.0.1 dev ens3 
```

__Docs__
- https://conglinh.com/2856-huong-dan-cau-hinh-nexus-switch.html
- https://www.cisco.com/c/en/us/td/docs/switches/datacenter/nexus9000/sw/7-x/interfaces/configuration/guide/b_Cisco_Nexus_9000_Series_NX-OS_Interfaces_Configuration_Guide_7x/b_Cisco_Nexus_9000_Series_NX-OS_Interfaces_Configuration_Guide_7x_chapter_01100.html