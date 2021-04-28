resource "kubernetes_service" "es-mediawiki" {
  metadata {
    name = "es-mediawiki"
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
      app = "es-mediawiki"
    }
  }
}

resource "kubernetes_deployment" "es-mediawiki" {
  metadata {
    name = "es-mediawiki"
  }

  spec {
    selector {
      match_labels = {
        app = "es-mediawiki"
      }
    }

    template {
      metadata {
        labels = {
          app = "es-mediawiki"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "es-mediawiki-persistent-storage"

          persistent_volume_claim {
            claim_name = "es-mediawiki-pvc"
          }
        }

        security_context {
          fs_group = 1000
        }

        container {
          name  = "es-mediawiki"
          image = "elasticsearch:6.8.13"
          resources {
            limits {
              memory = "2.0Gi"
            }
            requests {
              cpu    = "200m"
              memory = "1.5Gi"
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
            value = "-Xmx768m -Xms768m"
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
            name       = "es-mediawiki-persistent-storage"
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

resource "kubernetes_persistent_volume_claim" "es-mediawiki-pvc" {
  metadata {
    name      = "es-mediawiki-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "15Gi"
      }
    }

    storage_class_name = "linode-block-storage-retain"
  }
}
