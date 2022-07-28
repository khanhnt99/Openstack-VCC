#!/bin/bash -ex 
# 
source config.cfg  
LOCAL_IP=`ifconfig ens3 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`  
echo "##### Install keystone #####"  
apt install keystone -y 

#/* Back-up file keystone.conf 
filekeystone=/etc/keystone/keystone.conf 
test -f $filekeystone.orig || cp $filekeystone $filekeystone.orig

#Config file /etc/keystone/keystone.conf 
cat << EOF > $filekeystone  
[DEFAULT]
log_dir = /var/log/keystone
bind_host = $VIP_IP
public_bind_host = $VIP_IP
admin_bind_host = $VIP_IP

[memcache] servers = localhost:11211

[database]
connection = mysql+pymysql://keystone:123456@$VIP_IP/keystone

[token]
provider = fernet
[catalog]
driver = keystone.catalog.backends.sql.Catalog
[identity]
driver = keystone.identity.backends.sql.Identity
EOF

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://$LOCAL_IP:5000/v3/ \
  --bootstrap-internal-url http://$LOCAL_IP:5000/v3/ \
  --bootstrap-public-url http://$LOCAL_IP:5000/v3/ \
  --bootstrap-region-id RegionOne


# Config apache
echo "ServerName $LOCAL_IP" >> /etc/apache2/apache2.conf
service apache2 restart

rm -f /var/lib/keystone/keystone.db

export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://$HOST_CTL:5000/v3
export OS_IDENTITY_API_VERSION=3

openstack project create --domain default --description "Service Project" service
	  
openstack project create --domain default --description "Demo Project" myproject

openstack user create --domain default --password $DEMO_PASS myuser

openstack role create myrole

openstack role add --project myproject --user myuser user

echo "export OS_PROJECT_DOMAIN_NAME=Default" >> admin-openrc
echo "export OS_USER_DOMAIN_NAME=Default" >> admin-openrc
echo "export OS_PROJECT_NAME=admin" >> admin-openrc
echo "export OS_USERNAME=admin" >> admin-openrc
echo "export OS_PASSWORD=$ADMIN_PASS" >> admin-openrc
echo "export OS_AUTH_URL=http://$VIP_IP:5000/v3" >> admin-openrc
echo "export OS_IDENTITY_API_VERSION=3" >> admin-openrc
echo "export OS_IMAGE_API_VERSION=2" >> admin-openrc

echo "export OS_PROJECT_DOMAIN_NAME=Default" >> demo-openrc
echo "export OS_USER_DOMAIN_NAME=Default" >> demo-openrc
echo "export OS_PROJECT_NAME=myproject" >> demo-openrc
echo "export OS_USERNAME=myuser" >> demo-openrc
echo "export OS_PASSWORD=$DEMO_PASS" >> demo-openrc
echo "export OS_AUTH_URL=http://$VIP_IP:5000/v3" >> demo-openrc
echo "export OS_IDENTITY_API_VERSION=3" >> demo-openrc
echo "export OS_IMAGE_API_VERSION=2" >> demo-openrc

openstack --os-auth-url http://$VIP_IP:5000/v3 \
--os-project-domain-name Default --os-user-domain-name Default \
--os-project-name admin --os-username admin token issue

openstack --os-auth-url http://$VIP_IP:5000/v3 \
--os-project-domain-name Default --os-user-domain-name Default \
--os-project-name myproject --os-username myuser token issue