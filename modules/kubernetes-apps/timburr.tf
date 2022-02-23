resource "kubernetes_deployment" "timburr" {
  metadata {
    name = "timburr"
  }

  spec {
    selector {
      match_labels = {
        app = "timburr"
      }
    }

    template {
      metadata {
        labels = {
          app = "timburr"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "timburr-config"

          config_map {
            name = "timburr"
          }
        }

        container {
          name  = "timburr"
          image = "ghcr.io/mudkipme/timburr:latest"

          resources {
            limits = {
              memory = "512Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          env {
            name = "TIMBURR_PURGE_CFTOKEN"
            value_from {
              secret_key_ref {
                name = "cloudflare"
                key  = "token"
              }
            }
          }

          port {
            name           = "fluentd-52w"
            container_port = 5001
          }

          volume_mount {
            name       = "timburr-config"
            read_only  = true
            mount_path = "/app/conf/config.yml"
            sub_path   = "config.yml"
          }

          image_pull_policy = "Always"
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
