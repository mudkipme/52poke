resource "kubernetes_cron_job_v1" "backup-mysql" {
  metadata {
    name = "backup-mysql"
  }

  spec {
    schedule = "0 20 * * *"

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

          spec {
            container {
              name  = "backup-mysql"
              image = "mudkip/mysql-backup-b2:latest"

              env {
                name  = "MYSQL_HOST"
                value = "mysql"
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
                name  = "B2_TARGET"
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
