resource "kubernetes_service" "kafka" {
  metadata {
    name = "kafka-inside"
  }

  spec {
    port {
      port = 9092
    }

    selector = {
      app = "kafka"
    }
  }
}

resource "kubernetes_deployment" "kafka" {
  metadata {
    name = "kafka"
  }

  spec {
    selector {
      match_labels = {
        app = "kafka"
      }
    }

    template {
      metadata {
        labels = {
          app = "kafka"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "kafka-persistent-storage"

          persistent_volume_claim {
            claim_name = "kafka-pvc"
          }
        }

        security_context {
          fs_group = 1000
        }

        container {
          name  = "kafka"
          image = "confluentinc/cp-kafka"

          resources {
            limits {
              cpu    = "1"
              memory = "1Gi"
            }
            requests {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          port {
            name           = "kafka"
            container_port = 9092
          }

          env {
            name  = "KAFKA_HEAP_OPTS"
            value = "-Xmx256M -Xms256M"
          }

          env {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = "zookeeper.default.svc.cluster.local"
          }

          env {
            name  = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP"
            value = "INSIDE:PLAINTEXT"
          }

          env {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "INSIDE://kafka-inside.default.svc.cluster.local:9092"
          }

          env {
            name  = "KAFKA_LISTENERS"
            value = "INSIDE://:9092"
          }

          env {
            name  = "KAFKA_INTER_BROKER_LISTENER_NAME"
            value = "INSIDE"
          }

          env {
            name  = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR"
            value = "1"
          }

          volume_mount {
            name       = "kafka-persistent-storage"
            mount_path = "/var/lib/kafka/data"
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

resource "kubernetes_persistent_volume_claim" "kafka_pvc" {
  metadata {
    name      = "kafka-pvc"
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

