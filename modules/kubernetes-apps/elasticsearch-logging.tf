resource "kubernetes_service" "elasticsearch-logging" {
  metadata {
    name = "elasticsearch-logging"
  }

  spec {
    port {
      name = "es"
      port = 9200
    }

    port {
      name = "es-control"
      port = 9300
    }

    selector = {
      app = "elasticsearch-logging"
    }
  }
}

resource "kubernetes_deployment" "elasticsearch-logging" {
  metadata {
    name = "elasticsearch-logging"
  }

  spec {
    selector {
      match_labels = {
        app = "elasticsearch-logging"
      }
    }

    template {
      metadata {
        labels = {
          app = "elasticsearch-logging"
        }
      }

      spec {
        volume {
          name = "elasticsearch-logging-persistent-storage"

          persistent_volume_claim {
            claim_name = "elasticsearch-logging-pvc"
          }
        }

        security_context {
          fs_group = 1000
        }

        container {
          name  = "elasticsearch"
          image = "elasticsearch:7.9.3"

          resources {
            limits {
              memory = "2Gi"
            }
            requests {
              cpu    = "100m"
              memory = "1Gi"
            }
          }

          port {
            name           = "es"
            container_port = 9200
          }

          port {
            name           = "es-control"
            container_port = 9300
          }

          env {
            name  = "ES_JAVA_OPTS"
            value = "-Xmx512m -Xms512m"
          }

          env {
            name  = "discovery.type"
            value = "single-node"
          }

          env {
            name  = "xpack.security.enabled"
            value = "false"
          }

          volume_mount {
            name       = "elasticsearch-logging-persistent-storage"
            mount_path = "/usr/share/elasticsearch/data"
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

resource "kubernetes_persistent_volume_claim" "elasticsearch-logging-pvc" {
  metadata {
    name      = "elasticsearch-logging-pvc"
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
