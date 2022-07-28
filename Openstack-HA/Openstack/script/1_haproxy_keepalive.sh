#!/bin/bash -ex  
if [ $(hostname) = "controller-1" ]; then 
    export priority="101";
elif [ $(hostname) = "controller-2" ]; then 
    export priority="100";
elif [ $(hostname) = "controller-3" ]; then 
    export priority="99";
fi

apt-get install haproxy keepalived -y  
echo "###### Configure keepalived #####" sleep 3

cat << EOF > /etc/keepalived/keepalived.conf 
vrrp_script haproxy {         
    script "killall -0 haproxy"         
    interval 2         
    weight 2 
} 

vrrp_instance LAN {         
    virtual_router_id 50         
    advert_int 2         
    priority $priority         
    state SLAVE         
    interface ens3
    virtual_ipaddress {                 
        10.10.10.4/24 dev ens3        
        }         
} 
EOF

service keepalived restart  
echo "###### Configure haproxy #####" sleep 3  
haproxyfile=/etc/haproxy/haproxy.cfg

cat << EOF > $haproxyfile 
global   
    chroot  /var/lib/haproxy   
    daemon   
    group  haproxy   
    maxconn  4000   
    pidfile  /var/run/haproxy.pid   
    stats socket /var/lib/haproxy/stats   
    user  haproxy 

defaults
    log     global
    mode    tcp
    retries 3
    timeout http-request 1-s
    timeout queue 1m
    timeout connect 10s
    timeout client 1m
    timeout server 1m
    timeout check 10s

listen keystone *:5000   
    balance  roundrobin   
    option  tcpka   
    option  httpchk 
    option  tcplog   
    server controller-1 10.10.10.130:5000 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.140:5000 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.150:5000 check inter 2000 rise 2 fall 5

listen glance_api *:9292   
    balance roundrobin   
    option  tcpka   
    option  httpchk   
    option  tcplog   
    server controller-1 10.10.10.1:9292 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:9292 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:9292 check inter 2000 rise 2 fall 5

listen placement_api *:8778
    balance  roundrobin   
    option  tcpka   
    option  httpchk   
    option  tcplog   
    server controller-1 10.10.10.1:8778 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:8778 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:8778 check inter 2000 rise 2 fall 5 

listen nova_api *:8774   
    balance  roundrobin   
    option  tcpka   
    option  httpchk   
    option  tcplog   
    server controller-1 10.10.10.1:8774 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:8774 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:8774 check inter 2000 rise 2 fall 5 

listen nova_metadata_api *:8775 
    balance  roundrobin
    option  tcpka   
    option  tcplog   
    server controller-1 10.10.10.1:8775 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:8775 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:8775 check inter 2000 rise 2 fall 5

listen nova_vncproxy *:6080   
    balance  roundrobin   
    option  tcpka   
    option  tcplog   
    server controller-1 10.10.10.1:6080 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:6080 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:6080 check inter 2000 rise 2 fall 5 

listen neutron_api *:9696   
    balance  roundrobin   
    option  tcpka   
    option  httpchk   
    option  tcplog   
    server controller-1 10.10.10.1:9696 check inter 2000 rise 2 fall 5   
    server controller-2 10.10.10.2:9696 check inter 2000 rise 2 fall 5   
    server controller-3 10.10.10.3:9696 check inter 2000 rise 2 fall 5

listen rabbitmq *:5672     
    balance  roundrobin     
    option clitcpka     
    timeout client 900m     
    server controller1 10.10.10.1:5672 check inter 1s     
    server controller2 10.10.10.2:5672 check inter 1s     
    server controller3 10.10.10.3:5672 check inter 1s 

listen stats *:1936
    mode http
    stats enable
    stats uri /stats
    stats realm HAProxy\ Statistics
    stats auth admin: 123456
EOF

service haproxy restart