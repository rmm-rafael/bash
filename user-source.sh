#!/bin/bash

#set -xe

if [ -z "$HOME" ]; then 
    echo "Seems you're \$HOMEless :("; 
    exit 1 
fi

# GO HOME
cd ${HOME}

export SH_DIR="$HOME/bash"

case ${1} in
    "ssh")
        SH_DIR="$SH_DIR/ssh"
        echo " # ssh commands " >> .bash_profile
        echo "source $SH_DIR/trust-keys.sh" >> .bash_profile
    ;;
    "scripts")
        SH_DIR="$SH_DIR/scripts"
        echo " # scripts commands " >> .bash_profile
        echo "source $SH_DIR/aws.sh" >> .bash_profile
        echo "source $SH_DIR/docker.sh" >> .bash_profile
    ;;
    "alias")
        SH_DIR="$SH_DIR/aliases"
        echo " # alias commands " >> .bash_profile
        echo "source $SH_DIR/mac.sh" >> .bash_profile
        echo "source $SH_DIR/shell.sh" >> .bash_profile
    ;;
    *)
        echo "All options (ssh, scripts, alias)"
        exit 1
    ;;
esac