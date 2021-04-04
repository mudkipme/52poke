#!/bin/sh

set -e

echo '[client]' > /root/.my.cnf
echo 'user=root' >> /root/.my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /root/.my.cnf

# Drop existing tables
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql --add-drop-table --no-data makeawish | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql makeawish

# Download and restore from backup
mkdir -p /tmp/mysql-restore
cd /tmp/mysql-restore
rclone copy b2:52poke-backup/database/makeawish.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc makeawish.sql.gz) | mysql -h mysql makeawish