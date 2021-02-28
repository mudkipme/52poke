resource "kubernetes_deployment" "discord_52poke" {
  metadata {
    name = "52poke-discord"
  }

  spec {
    selector {
      match_labels = {
        app = "52poke-discord"
      }
    }

    template {
      metadata {
        labels = {
          app = "52poke-discord"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "52poke-discord"
          image = "ghcr.io/mudkipme/52poke-discord:latest"
          resources {
            requests {
              cpu    = "50m"
              memory = "128Mi"
            }
            limits {
              memory = "256Mi"
            }
          }

          env {
            name = "TOKEN"
            value_from {
              secret_key_ref {
                name = "52poke-discord"
                key  = "token"
              }
            }
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
