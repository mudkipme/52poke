resource "kubernetes_job" "mysql-restore" {
  depends_on = [kubernetes_job.database-init]
  metadata {
    name = "mysql-restore"
  }

  spec {
    template {
      metadata {}

      spec {
        container {
          name  = "mysql-restore"
          image = "mudkip/mysql-backup-b2:latest"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-root"
                key  = "password"
              }
            }
          }

          env {
            name = "RCLONE_CONFIG_B2_ACCOUNT"

            value_from {
              secret_key_ref {
                name = "backblaze-b2"
                key  = "b2-account-id"
              }
            }
          }

          env {
            name = "RCLONE_CONFIG_B2_KEY"

            value_from {
              secret_key_ref {
                name = "backblaze-b2"
                key  = "b2-account-key"
              }
            }
          }

          command = ["/bin/sh", "-c", <<EOF
set -e

echo '[client]' > /root/.my.cnf
echo 'user=root' >> /root/.my.cnf
echo "password=$MYSQL_ROOT_PASSWORD" >> /root/.my.cnf

mysql -h mysql-pc 52poke_wiki <<SQL
DROP TABLE IF EXISTS objectcache; \

CREATE TABLE objectcache (
  keyname varbinary(255) NOT NULL default '' PRIMARY KEY,
  value mediumblob,
  exptime datetime
) ENGINE=InnoDB, DEFAULT CHARSET=utf8;
CREATE INDEX exptime ON objectcache (exptime);
SQL

mkdir -p /tmp/mysql-restore
cd /tmp/mysql-restore
rclone copy b2:52poke-backup/database/52poke.sql.gz .
gunzip < 52poke.sql.gz | mysql -h mysql 52poke
rclone copy b2:52poke-backup/database/52poke_bbs.sql.gz .
gunzip < 52poke_bbs.sql.gz | mysql -h mysql 52poke_bbs
rclone copy b2:52poke-backup/database/52poke_wiki.sql.gz .
gunzip < 52poke_wiki.sql.gz | mysql -h mysql 52poke_wiki
EOF
          ]
        }

        restart_policy = "Never"
      }
    }
  }
}