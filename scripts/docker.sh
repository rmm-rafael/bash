#!/bin/bash

#set -xe

source docker.conf

# docker stop all containers
function dockerStopAll() {
  for n in $(docker ps | awk '{print $1}'); do docker stop $n; done
}

# load all docker images on current dir where end with .docker
# this is valueable when your machine doesn´t have internet access.
function dockerLoadAllImages() {
  for n in $(ll | grep .docker | awk '{print $9}'); do 
    echo " load file $n"; 
    docker load -i $n 
  done
}

# save the images you have downloaded on your host with access internet
# param 1 - filter the images you need to save
function dockerSaveAll() {
  for n in $(docker images | grep $1 | awk '{print $1":"$2}'); do
    name="$(echo $n | cut -f 2 -d '/' | cut -f 1 -d ':').docker"
    echo " saving $name"
    docker save $n -o $name
  done
}

# Copy all images to isolated machine
# see trust-ssh.sh to undestand the easy access.
function dockerScpTo() {
  for n in $(ll | grep .docker | awk '{print $9}'); do 
    echo " copy file $n "; 
    # param 1 - destination, root@192.168.250.12:~
    scp $n $1
  done
}

# Copy all images to isolated machine
# works only on linux using sshpass
function dockerSshPassTo() {
  for n in $(ll | grep .docker | awk '{print $9}'); do 
    echo " copy file $n "; 
    # $1 - password
    # #2 - destination, root@192.168.250.12:~
    sshpass -p $1 scp $n $2
  done
}

# Configure aws login on docker
# param 1 - aws token url 
# param 2 - docker username
# param 3 - user from ssh key
function dockerConfigLogin() {
  NEW_TOKEN=$(curl -X POST $1 | jq .tokenAWS | sed -e 's/\"//g')
  docker login -u $2 -p ${NEW_TOKEN} $3
}

# Create a terminal with sql plus.
function dockerSql() {
    docker run --rm -e URL="$DB_USER/$DB_PASS@//$DB_HOST:1521/$DB_NAME" -ti sflyr/sqlplus
}