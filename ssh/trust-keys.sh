#!/bin/bash

#set -xe

# How to Setup Passwordless SSH Login
# https://linuxize.com/post/how-to-setup-passwordless-ssh-login/

# The easiest way to copy your public key to your server
# param 1 - username
# param 2 - machine host
function trustOnCopy() {
    ssh-copy-id $1@$2
}

# If by some reason the *ssh-copy-id* utility is not available on your local 
# computer you can use the following command to copy the public key.
# param 1 - username
# param 2 - machine host
# param 3 - ssh public key (default id_rsa.pub)
function trustOnShell() {
    KEY=id_rsa.pub
    if [ -n "${3}" ] ; then
        KEY=${3}
    fi
    cat ~/.ssh/$3 | ssh $1@$2 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

