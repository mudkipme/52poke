resource "kubernetes_service" "mysql-pc" {
  metadata {
    name = "mysql-pc"
  }

  spec {
    port {
      port = 3306
    }

    selector = {
      app = "mysql-pc"
    }
  }
}

resource "kubernetes_deployment" "mysql-pc" {
  metadata {
    name = "mysql-pc"
  }

  spec {
    selector {
      match_labels = {
        app = "mysql-pc"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql-pc"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "mysql-pc-persistent-storage"

          persistent_volume_claim {
            claim_name = "mysql-pc-pvc"
          }
        }

        container {
          name  = "mysql"
          image = "mysql:8"
          args  = ["--default-authentication-plugin=mysql_native_password", "--character-set-server=utf8", "--collation-server=utf8_general_ci", "--skip-log-bin"]

          resources {
            limits {
              memory = "768Mi"
            }
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          port {
            name           = "mysql"
            container_port = 3306
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = "mysql-root"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "mysql-pc-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mysql-pc-pvc" {
  metadata {
    name      = "mysql-pc-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = "linode-block-storage"
  }
}
