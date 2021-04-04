resource "kubernetes_ingress" "makeawish" {
  metadata {
    name = "makeawish"
    annotations = {
      "cert-manager.io/cluster-issuer" = "le-wildcard-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["makeawish.52poke.net"]
      secret_name = "makeawish-tls"
    }

    rule {
      host = "makeawish.52poke.net"

      http {
        path {
          path = "/"

          backend {
            service_name = "makeawish"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "makeawish" {
  metadata {
    name = "makeawish"
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app = "makeawish"
    }
  }
}

resource "kubernetes_deployment" "makeawish" {
  metadata {
    name = "makeawish"
  }

  spec {
    selector {
      match_labels = {
        app = "makeawish"
      }
    }

    template {
      metadata {
        labels = {
          app = "makeawish"
        }
      }

      spec {
        volume {
          name = "makeawish-config"

          config_map {
            name = "makeawish"
          }
        }

        enable_service_links = false

        container {
          name  = "makeawish"
          image = "ghcr.io/mudkipme/makeawish:latest"

          resources {
            limits {
              memory = "512Mi"
            }
            requests {
              cpu    = "50m"
              memory = "128Mi"
            }
          }

          env {
            name = "APP_KEY"
            value_from {
              secret_key_ref {
                name = "makeawish"
                key  = "appKey"
              }
            }
          }

          env {
            name = "DB_USERNAME"
            value_from {
              secret_key_ref {
                name = "mysql-makeawish"
                key  = "username"
              }
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-makeawish"
                key  = "password"
              }
            }
          }

          env {
            name = "AWS_ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                name = "aws-s3"
                key  = "accessKeyID"
              }
            }
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = "aws-s3"
                key  = "secretAccessKey"
              }
            }
          }

          port {
            container_port = 80
          }

          volume_mount {
            name       = "makeawish-config"
            read_only  = true
            mount_path = "/var/www/html/.env"
            sub_path   = ".env"
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
