resource "kubernetes_ingress" "klinklang" {
  metadata {
    name = "klinklang"

    annotations = {
      "cert-manager.io/cluster-issuer" = "le-cloudflare-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.wiki", "www.52poke.wiki", "s0.52poke.wiki", "s1.52poke.wiki", "util.52poke.wiki"]
      secret_name = "52poke-wiki-tls"
    }

    rule {
      host = "util.52poke.wiki"

      http {
        path {
          backend {
            service_name = "klinklang"
            service_port = "3000"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "klinklang" {
  metadata {
    name = "klinklang"
  }

  spec {
    port {
      port = 3000
    }

    selector = {
      app = "klinklang"
    }
  }
}

resource "kubernetes_deployment" "klinklang" {
  metadata {
    name = "klinklang"
  }

  spec {
    selector {
      match_labels = {
        app = "klinklang"
      }
    }

    template {
      metadata {
        labels = {
          app = "klinklang"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "klinklang-config"

          config_map {
            name = "klinklang"
          }
        }

        container {
          name  = "klinklang"
          image = "ghcr.io/mudkipme/klinklang:latest"

          resources {
            requests {
              cpu    = "50m"
              memory = "256Mi"
            }
          }

          port {
            container_port = 3000
          }

          env {
            name = "KLINKLANG_SECRET"
            value_from {
              secret_key_ref {
                name = "klinklang"
                key  = "secret"
              }
            }
          }

          env {
            name = "WIKI_OAUTH_KEY"
            value_from {
              secret_key_ref {
                name = "klinklang"
                key  = "wiki-oauth-key"
              }
            }
          }

          env {
            name = "WIKI_OAUTH_SECRET"
            value_from {
              secret_key_ref {
                name = "klinklang"
                key  = "wiki-oauth-secret"
              }
            }
          }

          env {
            name = "DATABASE_USERNAME"
            value_from {
              secret_key_ref {
                name = "postgres-klinklang"
                key  = "username"
              }
            }
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = "postgres-klinklang"
                key  = "password"
              }
            }
          }

          env {
            name = "DISCORD_TOKEN"
            value_from {
              secret_key_ref {
                name = "52poke-discord"
                key  = "token"
              }
            }
          }

          volume_mount {
            name       = "klinklang-config"
            read_only  = true
            mount_path = "/app/config.json"
            sub_path   = "config.json"
          }

          volume_mount {
            name       = "klinklang-config"
            read_only  = true
            mount_path = "/app/workflow.yml"
            sub_path   = "workflow.yml"
          }

          command = ["npm", "run", "serve"]
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
