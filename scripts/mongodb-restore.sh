#!/bin/sh

set -e

mkdir -p /tmp/mongodb-restore
cd /tmp/mongodb-restore

rclone copy backup:52poke-backup/database/paradise.tar.gz .
tar xf paradise.tar.gz
find . -type f -name "*.metadata.json" -exec sed -i 's/,"safe":null//g' {} \;
mongorestore --host mongodb -d paradise --username root --password $MONGO_ROOT_PASSWORD --authenticationDatabase admin --drop paradise

rclone copy backup:52poke-backup/database/forums.tar.gz .
tar xf forums.tar.gz
find . -type f -name "*.metadata.json" -exec sed -i 's/,"safe":null//g' {} \;
mongorestore --host mongodb -d forums --username root --password $MONGO_ROOT_PASSWORD --authenticationDatabase admin --drop forums