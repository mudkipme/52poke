resource "kubernetes_cron_job_v1" "backup-nfs" {
  metadata {
    name = "backup-nfs"
  }

  spec {
    schedule = "0 21 * * 4"

    job_template {
      metadata {}

      spec {
        template {
          metadata {}

          spec {
            volume {
              name = "pvc-52poke-forums"

              persistent_volume_claim {
                claim_name = "pvc-52poke-forums"
              }
            }

            volume {
              name = "pvc-52poke-forums-legacy"

              persistent_volume_claim {
                claim_name = "pvc-52poke-forums-legacy"
              }
            }

            volume {
              name = "pvc-52poke-www"

              persistent_volume_claim {
                claim_name = "pvc-52poke-www"
              }
            }

            volume {
              name = "pvc-52poke-paradise-legacy"

              persistent_volume_claim {
                claim_name = "pvc-52poke-paradise-legacy"
              }
            }

            container {
              name  = "backup-nfs"
              image = "restic/restic:latest"

              env {
                name = "RESTIC_PASSWORD"
                value_from {
                  secret_key_ref {
                    name = "restic"
                    key  = "password"
                  }
                }
              }

              env {
                name = "B2_ACCOUNT_ID"

                value_from {
                  secret_key_ref {
                    name = "backblaze-b2"
                    key  = "b2-account-id"
                  }
                }
              }

              env {
                name = "B2_ACCOUNT_KEY"

                value_from {
                  secret_key_ref {
                    name = "backblaze-b2"
                    key  = "b2-account-key"
                  }
                }
              }

              volume_mount {
                name       = "pvc-52poke-forums"
                mount_path = "/srv/nfs/app/52poke-forums"
              }

              volume_mount {
                name       = "pvc-52poke-forums-legacy"
                mount_path = "/srv/nfs/app/52poke-forums-legacy"
              }

              volume_mount {
                name       = "pvc-52poke-www"
                mount_path = "/srv/nfs/app/52poke-www"
              }

              volume_mount {
                name       = "pvc-52poke-paradise-legacy"
                mount_path = "/srv/nfs/app/paradise"
              }

              command = ["/bin/sh", "-c", "restic -r b2:52poke-backup:nfs backup /srv/nfs"]
            }

            restart_policy = "OnFailure"
          }
        }
      }
    }

    successful_jobs_history_limit = 1
  }
}
