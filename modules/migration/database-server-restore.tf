resource "kubernetes_job" "database-server-restore" {
  count = 0

  depends_on = [kubernetes_job.database-init]
  metadata {
    name = "database-server-restore"
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
                name = "mysql-server"
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

          command = ["/bin/sh", "-c", file("${path.root}/scripts/20210531-mysql-restore.sh")]
        }

        restart_policy = "Never"
      }
    }
  }
}