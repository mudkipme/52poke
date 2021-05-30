#!/bin/bash
# <UDF name="mysql_root_password" label="MySQL Root Password" example="" default="">
# <UDF name="mysql_port" label="MySQL Port" example="3306" default="">
# <UDF name="mysql_pc_port" label="MySQL Private Cache Port" example="3308" default="">

# Install Docker
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt update
apt install -y docker-ce

PRIVATE_IP=`ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep 192.168`

docker run --name mysql -v mysql:/var/lib/mysql -p ${PRIVATE_IP}:${MYSQL_PORT}:3306 -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -d mysql:8 \
  --default-authentication-plugin=mysql_native_password \
  --character-set-server=utf8 \
  --collation-server=utf8_general_ci \
  --binlog-expire-logs-seconds=604800 \
  --slow-query-log=on

docker run --name mysql-pc -v mysql-pc:/var/lib/mysql -p ${PRIVATE_IP}:${MYSQL_PC_PORT}:3306 -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -d mysql:8 \
  --default-authentication-plugin=mysql_native_password \
  --character-set-server=utf8 \
  --collation-server=utf8_general_ci \
  --skip-log-bin
