resource "kubernetes_cron_job" "backup-mongodb" {
  metadata {
    name = "backup-mongodb"
  }

  spec {
    schedule = "0 19 * * *"

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

          spec {
            container {
              name  = "backup-mongodb"
              image = "mudkip/mongodb-backup-b2:latest"

              env {
                name  = "MONGO_HOST"
                value = "mongodb"
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
                name  = "BACKUP_TARGET"
                value = "52poke-backup/database"
              }
            }

            restart_policy = "OnFailure"
          }
        }
      }
    }

    successful_jobs_history_limit = 1
  }
}
