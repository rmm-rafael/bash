#!/bin/bash

#set -xe

source proxy.conf

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce device-mapper-persistent-data lvm2 

mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
EOF

if [ -n "${PASS_PROXY_DEFAULT}" ] ; then
    echo "Environment='HTTP_PROXY=$PASS_PROXY_DEFAULT'" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment='HTTPS_PROXY=$PASS_PROXY_DEFAULT'" >> /etc/systemd/system/docker.service.d/http-proxy.conf
fi

if [ -n "${NO_PROXY_DEFAULT}" ] ; then
    echo "Environment='NO_PROXY=$NO_PROXY_DEFAULT'" >> /etc/systemd/system/docker.service.d/http-proxy.conf
fi

systemctl daemon-reload
systemctl start docker
systemctl enable docker