#!/bin/bash

#set -xe

if [ "${1}" == "init" ] ; then
    INIT=true
fi
    
# disable swap
echo 'disable swap to k8s' 
swapoff -a
sed -ie 's:\(.*\)\s\(swap\)\s\s*\(\w*\)\s*\(\w*\)\s*\(.*\):# \1 \2 \3 \4 \5:' /etc/fstab

# change selinux to permissive
echo 'disable selinux to k8s' 
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# open kubernetes ports
echo 'open firewall ports to k8s' 
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --set-target=ACCEPT
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=443/tcp # server API server
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=80/tcp # server API server
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=6443/tcp # Kubernetes API server
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=2379-2380/tcp # etcd server client API
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=10250/tcp # Kubelet API
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=10251/tcp # kube-scheduler
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=10252/tcp # kube-controller-manager
firewall-cmd --permanent --zone="$(firewall-cmd --get-default-zone)" --add-port=30000-32767/tcp # NodePort Services
firewall-cmd --reload
    
# disable ipv6
echo 'disable ipv6 to k8s' 
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
    
# install kubernetes
echo 'start installing k8s' 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
    
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl start kubelet
systemctl enable kubelet

# download kubernetes images
echo 'download k8s images' 
kubeadm config images pull

# easy access
source <(kubeadm completion bash)
echo "source <(kubeadm completion bash)" >> ~/.bashrc
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

if [ -n "${INIT}" ]; then
    
    # Warning: Here you may need to unset the proxy configs

    echo 'init k8s master' 
    # run kube adm
    kubeadm init --pod-network-cidr=10.244.0.0/16
    
    # enable to run kubectl to cluster
    echo 'enable kubectl to cluster' 
    mkdir -p ${HOME}/.kube
    yes | cp /etc/kubernetes/admin.conf ${HOME}/.kube/config
    chown $(id -u):$(id -g) ${HOME}/.kube/config
    
    # enable to run application on node master
    echo 'taint k8s master'
    kubectl taint nodes --all node-role.kubernetes.io/master-
    
fi
   