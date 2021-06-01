#!/bin/sh

set -e

echo '[client]' > /root/.my.cnf
echo 'user=root' >> /root/.my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /root/.my.cnf

mysql -h mysql-pc-server 52poke_wiki <<SQL
DROP TABLE IF EXISTS objectcache; \

CREATE TABLE objectcache (
  keyname varbinary(255) NOT NULL default '' PRIMARY KEY,
  value mediumblob,
  exptime datetime
) ENGINE=InnoDB, DEFAULT CHARSET=utf8;
CREATE INDEX exptime ON objectcache (exptime);
SQL

# Drop existing tables
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql-server --add-drop-table --no-data 52poke | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql-server 52poke
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql-server --add-drop-table --no-data 52poke_bbs | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql-server 52poke_bbs
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql-server --add-drop-table --no-data 52poke_wiki | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql-server 52poke_wiki
echo "SET FOREIGN_KEY_CHECKS = 0;" $(mysqldump -h mysql-server --add-drop-table --no-data makeawish | grep 'DROP TABLE') "SET FOREIGN_KEY_CHECKS = 1;" | mysql -h mysql-server makeawish


# Download and restore from backup
mkdir -p /tmp/mysql-restore
cd /tmp/mysql-restore
rclone copy b2:52poke-backup/database/52poke.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc 52poke.sql.gz) | mysql -h mysql-server 52poke
rclone copy b2:52poke-backup/database/52poke_bbs.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc 52poke_bbs.sql.gz) | mysql -h mysql-server 52poke_bbs
rclone copy b2:52poke-backup/database/52poke_wiki.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc 52poke_wiki.sql.gz) | mysql -h mysql-server 52poke_wiki
rclone copy b2:52poke-backup/database/makeawish.sql.gz .
(echo "SET SESSION SQL_LOG_BIN=0;"; gzip -dc makeawish.sql.gz) | mysql -h mysql-server makeawish