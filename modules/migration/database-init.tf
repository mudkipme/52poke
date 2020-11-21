resource "kubernetes_job" "database-init" {
  metadata {
    name = "database-init"
  }

  spec {
    template {
      metadata {}

      spec {
        volume {
          name = "terraform-database"

          config_map {
            name = "terraform-database"
          }
        }

        volume {
          name = "database-init"

          persistent_volume_claim {
            claim_name = "pvc-database-init"
          }
        }

        container {
          name  = "database-provision"
          image = "hashicorp/terraform:light"

          env {
            name = "MYSQL_USERNAME"
            value_from {
              secret_key_ref {
                name = "mysql-root"
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-root"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_mysql_wiki_password"
            value_from {
              secret_key_ref {
                name = "mysql-wiki"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_mysql_www_password"
            value_from {
              secret_key_ref {
                name = "mysql-www"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_mysql_legacyforums_password"
            value_from {
              secret_key_ref {
                name = "mysql-legacyforums"
                key  = "password"
              }
            }
          }

          command = ["/bin/sh", "-c", <<EOF
set -e
cd /mnt/database-init
cp -r /mnt/terraform-database/. .
terraform init
terraform apply -auto-approve
EOF
          ]

          volume_mount {
            name       = "terraform-database"
            mount_path = "/mnt/terraform-database"
          }

          volume_mount {
            name       = "database-init"
            mount_path = "/mnt/database-init"
          }
        }
        restart_policy = "Never"
      }
    }
  }

  wait_for_completion = true
}

resource "kubernetes_persistent_volume_claim" "pvc-database-init" {
  metadata {
    name      = "pvc-database-init"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "100Mi"
      }
    }

    storage_class_name = "nfs"
  }
}
