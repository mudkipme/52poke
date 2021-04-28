resource "kubernetes_ingress" "pokeapi" {
  metadata {
    name = "pokeapi"
    annotations = {
      "cert-manager.io/cluster-issuer"              = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/limit-rpm"       = "120"
      "nginx.ingress.kubernetes.io/limit-whitelist" = "10.0.0.0/8"
    }
  }

  spec {
    tls {
      hosts       = ["pokeapi.52poke.com"]
      secret_name = "pokeapi-52poke-tls"
    }

    rule {
      host = "pokeapi.52poke.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "pokeapi"
            service_port = "8000"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pokeapi" {
  metadata {
    name = "pokeapi"
  }

  spec {
    port {
      port = 8000
    }

    selector = {
      app = "pokeapi"
    }
  }
}

resource "kubernetes_deployment" "pokeapi" {
  metadata {
    name = "pokeapi"
  }

  spec {
    selector {
      match_labels = {
        app = "pokeapi"
      }
    }

    template {
      metadata {
        labels = {
          app = "pokeapi"
        }
      }

      spec {

        volume {
          name = "config-pokeapi"

          config_map {
            name = "config-pokeapi"
          }
        }

        container {
          name  = "pokeapi"
          image = "mudkip/pokeapi:latest"
          resources {
            requests {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits {
              memory = "512Mi"
            }
          }

          port {
            container_port = 8000
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = "postgres-pokeapi"
                key  = "username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "postgres-pokeapi"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "config-pokeapi"
            mount_path = "/code/config/docker-compose.py"
            sub_path   = "pokeapi.py"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
