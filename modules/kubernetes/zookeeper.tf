resource "kubernetes_service" "zookeeper" {
  metadata {
    name = "zookeeper"
  }

  spec {
    port {
      port = 2181
    }

    selector = {
      app = "zookeeper"
    }
  }
}

resource "kubernetes_deployment" "zookeeper" {
  metadata {
    name = "zookeeper"
  }

  spec {
    selector {
      match_labels = {
        app = "zookeeper"
      }
    }

    template {
      metadata {
        labels = {
          app = "zookeeper"
        }
      }

      spec {
        volume {
          name = "zookeeper-persistent-storage"

          persistent_volume_claim {
            claim_name = "zookeeper-pvc"
          }
        }

        container {
          name  = "zookeeper"
          image = "zookeeper"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          port {
            name           = "zookeeper"
            container_port = 2181
          }

          volume_mount {
            name       = "zookeeper-persistent-storage"
            mount_path = "/data"
            sub_path   = "data"
          }

          volume_mount {
            name       = "zookeeper-persistent-storage"
            mount_path = "/datalog"
            sub_path   = "datalog"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "zookeeper_pvc" {
  metadata {
    name      = "zookeeper-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }

    storage_class_name = "longhorn"
  }
}
