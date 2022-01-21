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
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "kafka-persistent-storage"

          persistent_volume_claim {
            claim_name = "kafka-zk-pvc"
          }
        }

        container {
          name  = "zookeeper"
          image = "zookeeper"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          port {
            name           = "zookeeper"
            container_port = 2181
          }

          volume_mount {
            name       = "kafka-persistent-storage"
            mount_path = "/data"
            sub_path   = "zookeeper-data"
          }

          volume_mount {
            name       = "kafka-persistent-storage"
            mount_path = "/datalog"
            sub_path   = "zookeeper-datalog"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}