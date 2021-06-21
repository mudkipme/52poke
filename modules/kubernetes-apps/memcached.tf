resource "kubernetes_service" "memcached" {
  metadata {
    name = "memcached"
  }

  spec {
    port {
      port = 11211
    }

    selector = {
      app = "memcached"
    }
  }
}

resource "kubernetes_deployment" "memcached" {
  metadata {
    name = "memcached"
  }

  spec {
    selector {
      match_labels = {
        app = "memcached"
      }
    }

    template {
      metadata {
        labels = {
          app = "memcached"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "memcached"
          image = "memcached"

          resources {
            limits = {
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          port {
            name           = "memcached"
            container_port = 11211
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
