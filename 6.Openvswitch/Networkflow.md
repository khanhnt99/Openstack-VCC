# Network Flow sử dụng Openvswitch 
![](https://i.ibb.co/9s9H98y/Screenshot-from-2021-05-20-15-27-52.png)

## 1. Provider network 
- Gói tin sẽ đi từ eth0 của máy ảo, eth0 này sẽ nối với `tap` device trên host compute. 
- `tap` device này ở trên Linux Bridge.
- Việc có 1 Layer Linux Bridge vì Openstack sử dụng các rules của Iptables trên `tap` để thực hiện security groups.

### Linux Bridge
- Chứa các rules dùng cho security group, có 1 đầu là `tap` interface có địa chỉ MAC trùng với MAC trên card máy ảo.
- Đầu còn lại của Linux Bridge là `qvb` được nối với `qvo` trên `intefration bridge`.

### Integration Bridge
- Bridge này có tên là `br-int` thường được dùng để tag và untag VLAN cho traffic vào và ra VM.

```
  Bridge br-int
        Controller "tcp:127.0.0.1:6633"
            is_connected: true
        fail_mode: secure
        Port patch-tun
            Interface patch-tun
                type: patch
                options: {peer=patch-int}
        Port "qvoc5510431-6b"
            tag: 4
            Interface "qvoc5510431-6b"
        Port "qvofb992afb-4d"
            tag: 3
            Interface "qvofb992afb-4d"
        Port int-br-provider
            Interface int-br-provider
                type: patch
                options: {peer=phy-br-provider}
        Port br-int
            Interface br-int
                type: internal
```

### External Bridge
- Bridge được gắn với interface external để đi ra ngoài internet.

```
    Bridge br-provider
        Controller "tcp:127.0.0.1:6633"
            is_connected: true
        fail_mode: secure
        Port "ens3"
            Interface "ens3"
        Port br-provider
            Interface br-provider
                type: internal
        Port phy-br-provider
            Interface phy-br-provider
                type: patch
                options: {peer=int-br-provider}
    ovs_version: "2.9.8"
```

## 2. Self service network
- Traffic từ compute node sẽ được chuyển tới network node thông qua VXLAN tunnel trên bridge-tun `(br-tun)`.
- Nếu sử dụng VLAN thì nó sẽ chuyển đổi VLAN-tagged traffic từ intergration bridge sang VXLAN tunnels. Việc chuyển đổi này thực hiện bởi Openflow rules trên `br-tun`.
```
root@compute1:~# ovs-ofctl dump-flows br-tun
 cookie=0x2d2943b4d73d38b5, duration=83300.478s, table=0, n_packets=285, n_bytes=27809, priority=1,in_port="patch-int" actions=resubmit(,2)
 cookie=0x2d2943b4d73d38b5, duration=80183.831s, table=0, n_packets=137, n_bytes=18214, priority=1,in_port="vxlan-0a000a03" actions=resubmit(,4)
 cookie=0x2d2943b4d73d38b5, duration=83300.476s, table=0, n_packets=0, n_bytes=0, priority=0 actions=drop
 cookie=0x2d2943b4d73d38b5, duration=83300.474s, table=2, n_packets=155, n_bytes=16757, priority=0,dl_dst=00:00:00:00:00:00/01:00:00:00:00:00 actions=resubmit(,20)
 cookie=0x2d2943b4d73d38b5, duration=83300.472s, table=2, n_packets=130, n_bytes=11052, priority=0,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00 actions=resubmit(,22)
 cookie=0x2d2943b4d73d38b5, duration=83300.471s, table=3, n_packets=0, n_bytes=0, priority=0 actions=drop
 cookie=0x2d2943b4d73d38b5, duration=80186.252s, table=4, n_packets=137, n_bytes=18214, priority=1,tun_id=0x5 actions=mod_vlan_vid:4,resubmit(,10)
 cookie=0x2d2943b4d73d38b5, duration=83300.469s, table=4, n_packets=0, n_bytes=0, priority=0 actions=drop
 cookie=0x2d2943b4d73d38b5, duration=83300.468s, table=6, n_packets=0, n_bytes=0, priority=0 actions=drop
 cookie=0x2d2943b4d73d38b5, duration=83300.466s, table=10, n_packets=137, n_bytes=18214, priority=1 actions=learn(table=20,hard_timeout=300,priority=1,cookie=0x2d2943b4d73d38b5,NXM_OF_VLAN_TCI[0..11],NXM_OF_ETH_DST[]=NXM_OF_ETH_SRC[],load:0->NXM_OF_VLAN_TCI[],load:NXM_NX_TUN_ID[]->NXM_NX_TUN_ID[],output:OXM_OF_IN_PORT[]),output:"patch-int"
 cookie=0x2d2943b4d73d38b5, duration=80181.362s, table=20, n_packets=56, n_bytes=7727, priority=2,dl_vlan=4,dl_dst=fa:16:3e:0d:18:f8 actions=strip_vlan,load:0x5->NXM_NX_TUN_ID[],output:"vxlan-0a000a03"
 cookie=0x2d2943b4d73d38b5, duration=80181.360s, table=20, n_packets=98, n_bytes=8688, priority=2,dl_vlan=4,dl_dst=fa:16:3e:d5:d5:12 actions=strip_vlan,load:0x5->NXM_NX_TUN_ID[],output:"vxlan-0a000a03"
 cookie=0x2d2943b4d73d38b5, duration=83300.464s, table=20, n_packets=1, n_bytes=342, priority=0 actions=resubmit(,22)
 cookie=0x2d2943b4d73d38b5, duration=80181.371s, table=22, n_packets=12, n_bytes=1418, priority=1,dl_vlan=4 actions=strip_vlan,load:0x5->NXM_NX_TUN_ID[],output:"vxlan-0a000a03"
 cookie=0x2d2943b4d73d38b5, duration=83300.463s, table=22, n_packets=119, n_bytes=9976, priority=0 actions=drop
```

### DHCP on Network node
- Là một namespace sử dụng `dnsmasq` 

### Router on Network node
- Router là một network namespace với các rules và iptables rules để thực hiện việc định tuyến giữa các subnets.

```
root@network:~# ip netns e qrouter-d13bb4af-86b1-4eb3-97b9-1ace7944a7d0 iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
neutron-l3-agent-PREROUTING  all  --  anywhere             anywhere            

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
neutron-l3-agent-OUTPUT  all  --  anywhere             anywhere            

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
neutron-l3-agent-POSTROUTING  all  --  anywhere             anywhere            
neutron-postrouting-bottom  all  --  anywhere             anywhere            

Chain neutron-l3-agent-OUTPUT (1 references)
target     prot opt source               destination         
DNAT       all  --  anywhere             192.168.10.114       to:192.0.2.8

Chain neutron-l3-agent-POSTROUTING (1 references)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             ! ctstate DNAT

Chain neutron-l3-agent-PREROUTING (1 references)
target     prot opt source               destination         
REDIRECT   tcp  --  anywhere             169.254.169.254      tcp dpt:http redir ports 9697
DNAT       all  --  anywhere             192.168.10.114       to:192.0.2.8

Chain neutron-l3-agent-float-snat (1 references)
target     prot opt source               destination         
SNAT       all  --  192.0.2.8            anywhere             to:192.168.10.114

Chain neutron-l3-agent-snat (1 references)
target     prot opt source               destination         
neutron-l3-agent-float-snat  all  --  anywhere             anywhere            
SNAT       all  --  anywhere             anywhere             to:192.168.10.101
SNAT       all  --  anywhere             anywhere             mark match ! 0x2/0xffff ctstate DNAT to:192.168.10.101

Chain neutron-postrouting-bottom (1 references)
target     prot opt source               destination         
neutron-l3-agent-snat  all  --  anywhere             anywhere             /* Perform source NAT on outgoing traffic. */
```


__Docs__
- https://github.com/hungnt1/Openstack_Research/blob/master/Neutron/9.%20OPS-Packet-Self-Service.md
- https://docs.openstack.org/mitaka/networking-guide/deploy-ovs-selfservice.html