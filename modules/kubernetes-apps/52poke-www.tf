resource "kubernetes_ingress" "www_52poke" {
  metadata {
    name = "52poke-www"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/from-to-www-redirect" = "true"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.com", "www.52poke.com"]
      secret_name = "52poke-tls"
    }

    rule {
      host = "52poke.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "www-52poke"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "baokemeng" {
  metadata {
    name = "baokemeng"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/from-to-www-redirect" = "true"
      "nginx.ingress.kubernetes.io/temporal-redirect"    = "https://www.portal-pokemon.com/"
    }
  }

  spec {
    tls {
      hosts       = ["baokemeng.com", "www.baokemeng.com"]
      secret_name = "baokemeng-tls"
    }

    rule {
      host = "baokemeng.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "www-52poke"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "www_52poke" {
  metadata {
    name = "www-52poke"
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app = "52poke-www"
    }
  }
}

resource "kubernetes_deployment" "www_52poke" {
  metadata {
    name = "52poke-www"
  }

  spec {
    selector {
      match_labels = {
        app = "52poke-www"
      }
    }

    template {
      metadata {
        labels = {
          app = "52poke-www"
        }
      }

      spec {

        volume {
          name = "52poke-www-persistent-storage"

          persistent_volume_claim {
            claim_name = "pvc-52poke-www"
          }
        }

        volume {
          name = "52poke-www-config"

          config_map {
            name = "52poke-www-config"
          }
        }

        security_context {
          fs_group = 33
        }

        container {
          name  = "wordpress"
          image = "wordpress:php7.2-fpm"
          resources {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              memory = "512Mi"
            }
          }

          port {
            container_port = 9000
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "52poke"
          }

          env {
            name = "WORDPRESS_DB_USER"
            value_from {
              secret_key_ref {
                name = "mysql-www"
                key  = "username"
              }
            }
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-www"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "52poke-www-persistent-storage"
            mount_path = "/var/www/html"
          }
        }

        container {
          name  = "nginx"
          image = "nginx:latest"
          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              memory = "256Mi"
            }
          }

          port {
            container_port = 80
          }

          volume_mount {
            name       = "52poke-www-persistent-storage"
            mount_path = "/var/www/html"
          }

          volume_mount {
            name       = "52poke-www-config"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc-52poke-www" {
  metadata {
    name      = "pvc-52poke-www"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "3Gi"
      }
    }

    storage_class_name = "nfs"
  }
}
