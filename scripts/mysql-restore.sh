#!/bin/sh

set -e

echo '[client]' > /root/.my.cnf
echo 'user=root' >> /root/.my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /root/.my.cnf

# Drop existing tables
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql --add-drop-table --no-data 52poke | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql 52poke
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql --add-drop-table --no-data 52poke_bbs | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql 52poke_bbs

# Download and restore from backup
mkdir -p /tmp/mysql-restore
cd /tmp/mysql-restore
rclone copy b2:52poke-backup/database/52poke.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc 52poke.sql.gz) | mysql -h mysql 52poke
rclone copy b2:52poke-backup/database/52poke_bbs.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc 52poke_bbs.sql.gz) | mysql -h mysql 52poke_bbs