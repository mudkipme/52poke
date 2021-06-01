resource "kubernetes_namespace" "terraform" {
  metadata {
    name = "terraform"
  }
}

resource "kubernetes_service_account" "terraform" {
  metadata {
    name      = "terraform"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role" "terraform" {
  metadata {
    name = "terraform"
  }

  rule {
    verbs      = ["get", "update", "create", "list"]
    api_groups = [""]
    resources  = ["secrets"]
  }

  rule {
    verbs      = ["get", "update", "create"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}

resource "kubernetes_role_binding" "terraform" {
  metadata {
    name      = "terraform"
    namespace = "terraform"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "terraform"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "terraform"
  }
}

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

        automount_service_account_token = true

        container {
          name  = "database-provision"
          image = "hashicorp/terraform:light"

          env {
            name = "MYSQL_USERNAME"
            value_from {
              secret_key_ref {
                name = "mysql-server"
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-server"
                key  = "password"
              }
            }
          }

          env {
            name  = "KUBE_NAMESPACE"
            value = "terraform"
          }

          env {
            name = "MONGO_PWD"
            value_from {
              secret_key_ref {
                name = "mongodb"
                key  = "mongodb-root-password"
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

          env {
            name = "TF_VAR_mysql_makeawish_password"
            value_from {
              secret_key_ref {
                name = "mysql-makeawish"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_postgres_password"
            value_from {
              secret_key_ref {
                name = "postgres"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_postgres_pokeapi_password"
            value_from {
              secret_key_ref {
                name = "postgres-pokeapi"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_postgres_klinklang_password"
            value_from {
              secret_key_ref {
                name = "postgres-klinklang"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_mongodb_forums_password"
            value_from {
              secret_key_ref {
                name = "mongodb-forums"
                key  = "password"
              }
            }
          }

          env {
            name = "TF_VAR_mongodb_paradise_password"
            value_from {
              secret_key_ref {
                name = "mongodb-paradise"
                key  = "password"
              }
            }
          }

          command = ["/bin/sh", "-c", <<EOF
set -e
mkdir -p /tmp/database-init
cd /tmp/database-init
cp -r /mnt/terraform-database/. .
terraform init
terraform apply -auto-approve
EOF
          ]

          volume_mount {
            name       = "terraform-database"
            mount_path = "/mnt/terraform-database"
          }
        }

        service_account_name = "terraform"
        restart_policy       = "Never"
      }
    }
  }

  wait_for_completion = true
}
