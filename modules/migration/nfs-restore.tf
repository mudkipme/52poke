resource "kubernetes_job" "nfs-restore" {
  count = 0
  
  metadata {
    name = "nfs-restore"
  }

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
          name  = "nfs-restore"
          image = "restic/restic"

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

          command = ["/bin/sh", "-c", <<EOF
set -e
mkdir -p /tmp/nfs-data
restic -r b2:52poke-backup:nfs restore latest --target /tmp/nfs-data
cp -r /tmp/nfs-data/srv/nfs/app/52poke-forums/. /mnt/52poke-forums
cp -r /tmp/nfs-data/srv/nfs/app/52poke-forums-legacy/. /mnt/52poke-forums-legacy
cp -r /tmp/nfs-data/srv/nfs/app/52poke-www/. /mnt/52poke-www
cp -r /tmp/nfs-data/srv/nfs/app/paradise/. /mnt/52poke-paradise-legacy
EOF
          ]

          volume_mount {
            name       = "pvc-52poke-forums"
            mount_path = "/mnt/52poke-forums"
          }

          volume_mount {
            name       = "pvc-52poke-forums-legacy"
            mount_path = "/mnt/52poke-forums-legacy"
          }

          volume_mount {
            name       = "pvc-52poke-www"
            mount_path = "/mnt/52poke-www"
          }

          volume_mount {
            name       = "pvc-52poke-paradise-legacy"
            mount_path = "/mnt/52poke-paradise-legacy"
          }
        }
        restart_policy = "Never"
      }
    }
  }
}
