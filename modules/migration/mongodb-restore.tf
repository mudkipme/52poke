resource "kubernetes_job" "mongodb-restore" {
  depends_on = [kubernetes_job.database-init]
  metadata {
    name = "mongodb-restore"
  }

  spec {
    template {
      metadata {}

      spec {
        container {
          name  = "mongodb-restore"
          image = "mudkip/mongodb-backup-b2:latest"

          env {
            name = "MONGO_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongodb"
                key  = "mongodb-root-password"
              }
            }
          }

          env {
            name = "RCLONE_CONFIG_BACKUP_ACCOUNT"

            value_from {
              secret_key_ref {
                name = "backblaze-b2"
                key  = "b2-account-id"
              }
            }
          }

          env {
            name = "RCLONE_CONFIG_BACKUP_KEY"

            value_from {
              secret_key_ref {
                name = "backblaze-b2"
                key  = "b2-account-key"
              }
            }
          }

          command = ["/bin/sh", "-c", file("${path.root}/scripts/mongodb-restore.sh")]
        }

        restart_policy = "Never"
      }
    }
  }
}