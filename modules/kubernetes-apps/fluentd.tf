resource "kubernetes_service" "fluentd" {
  metadata {
    name = "logstash"
  }

  spec {
    port {
      name = "fluentd-52w"
      port = 5001
    }

    selector = {
      app = "fluentd"
    }
  }
}

resource "kubernetes_deployment" "fluentd" {
  metadata {
    name = "fluentd"
  }

  spec {
    selector {
      match_labels = {
        app = "fluentd"
      }
    }

    template {
      metadata {
        labels = {
          app = "fluentd"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "fluentd-config"

          config_map {
            name = "fluentd"
          }
        }

        container {
          name  = "fluentd"
          image = "mudkip/fluentd:latest"

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
            name           = "fluentd-52w"
            container_port = 5001
          }

          volume_mount {
            name       = "fluentd-config"
            read_only  = true
            mount_path = "/fluentd/etc"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

