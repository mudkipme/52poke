resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    port {
      port = 5432
    }

    selector = {
      app = "postgres"
    }
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"
  }

  spec {
    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "postgres-persistent-storage"

          persistent_volume_claim {
            claim_name = "postgres-pvc"
          }
        }

        container {
          name  = "postgres"
          image = "postgres:13"

          resources {
            limits {
              memory = "1Gi"
            }
            requests {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          port {
            name           = "postgres"
            container_port = 5432
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = "postgres"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "postgres-persistent-storage"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "data"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = "linode-block-storage-retain"
  }
}
