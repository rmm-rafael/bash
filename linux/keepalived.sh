#!/bin/bash

# set -xe

yum install -y keepalived

# Documentation: https://www.keepalived.org/manpage.html
echo 'change the configuration before execute'

mkdir -p /etc/keepalived/

# example of configuration..
cat <<EOF > /etc/keepalived/keepalived.conf
vrrp_instance vvmachine {
       state MASTER 
       interface ens192
       virtual_router_id 10
       priority 100
       advert_int 4
       authentication {
               auth_type PASS
               auth_pass abc
       }
       virtual_ipaddress {
               192.168.250.101
       }
}
EOF

#systemctl start keepalived
#systemctl enable keepalived