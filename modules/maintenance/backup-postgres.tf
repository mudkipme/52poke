resource "kubernetes_cron_job_v1" "backup-postgres" {
  metadata {
    name = "backup-postgres"
  }

  spec {
    schedule = "30 19 * * *"

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

          spec {
            container {
              name  = "backup-postgres"
              image = "mudkip/postgres-backup:latest"

              env {
                name  = "POSTGRES_HOST"
                value = "postgres"
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
                name = "PGPASSWORD"

                value_from {
                  secret_key_ref {
                    name = "postgres"
                    key  = "password"
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
