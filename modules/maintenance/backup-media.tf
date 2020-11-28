resource "kubernetes_cron_job" "backup-media" {
  metadata {
    name = "backup-media"
  }

  spec {
    schedule = "0 21 * * 1"

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

          spec {
            container {
              name  = "backup-media"
              image = "rclone/rclone:latest"

              env {
                name  = "RCLONE_CONFIG_MEDIA_TYPE"
                value = "s3"
              }

              env {
                name = "RCLONE_CONFIG_MEDIA_ACCESS_KEY_ID"

                value_from {
                  secret_key_ref {
                    name = "aws-s3"
                    key  = "accessKeyID"
                  }
                }
              }

              env {
                name = "RCLONE_CONFIG_MEDIA_SECRET_ACCESS_KEY"

                value_from {
                  secret_key_ref {
                    name = "aws-s3"
                    key  = "secretAccessKey"
                  }
                }
              }

              env {
                name  = "RCLONE_CONFIG_B2_TYPE"
                value = "b2"
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

              command = ["/bin/sh", "-c", "rclone sync --exclude wiki/thumb/** --exclude wiki/temp/** --exclude webp-cache/** media:media.52poke.com b2:52poke-backup/static/media"]
            }

            restart_policy = "OnFailure"
          }
        }
      }
    }

    successful_jobs_history_limit = 1
  }
}
