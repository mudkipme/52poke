resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    port {
      port = 3306
    }

    selector = {
      app = "mysql"
    }
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = "mysql"
  }

  spec {
    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "mysql-persistent-storage"

          persistent_volume_claim {
            claim_name = "mysql-pvc"
          }
        }

        container {
          name  = "mysql"
          image = "mysql:8"
          args  = ["--default-authentication-plugin=mysql_native_password", "--character-set-server=utf8", "--collation-server=utf8_general_ci", "--binlog-expire-logs-seconds=604800", "--slow-query-log=on"]

          resources {
            limits {
              memory = "1.5Gi"
            }
            requests {
              cpu    = "500m"
              memory = "1.5Gi"
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
            name       = "mysql-persistent-storage"
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

resource "kubernetes_persistent_volume_claim" "mysql_pvc" {
  metadata {
    name      = "mysql-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "50Gi"
      }
    }

    storage_class_name = "local-path"
  }
}
