resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
  }

  spec {
    port {
      port = 6379
    }

    selector = {
      app = "redis"
    }
  }
}

resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis"
  }

  spec {
    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        volume {
          name = "redis-persistent-storage"

          persistent_volume_claim {
            claim_name = "redis-pvc"
          }
        }

        container {
          name  = "redis"
          image = "redis"

          resources {
            limits {
              cpu    = "1"
              memory = "2Gi"
            }
            requests {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          port {
            name           = "redis"
            container_port = 6379
          }

          volume_mount {
            name       = "redis-persistent-storage"
            mount_path = "/data"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "redis_pvc" {
  metadata {
    name      = "redis-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "2Gi"
      }
    }

    storage_class_name = "longhorn"
  }
}

