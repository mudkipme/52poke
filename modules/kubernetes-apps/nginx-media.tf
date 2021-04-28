resource "kubernetes_ingress" "nginx-media" {
  metadata {
    name = "nginx-media"
    annotations = {
      "cert-manager.io/cluster-issuer"                = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/enable-access-log" = "false"
      "nginx.ingress.kubernetes.io/server-alias"      = "assets.52poke.com,static.52poke.com"
    }
  }

  spec {
    tls {
      hosts       = ["media.52poke.com"]
      secret_name = "media-52poke-tls"
    }

    rule {
      host = "media.52poke.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "nginx-media"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "nginx-media-net" {
  metadata {
    name = "nginx-media-net"
    annotations = {
      "cert-manager.io/cluster-issuer"                = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/enable-access-log" = "false"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.net", "www.52poke.net", "legacy.52poke.net", "media.52poke.net"]
      secret_name = "52poke-forums-tls"
    }

    rule {
      host = "media.52poke.net"

      http {
        path {
          path = "/"

          backend {
            service_name = "nginx-media"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "nginx-media-wiki" {
  metadata {
    name = "nginx-media-wiki"
    annotations = {
      "cert-manager.io/cluster-issuer"                = "le-cloudflare-issuer"
      "nginx.ingress.kubernetes.io/enable-access-log" = "false"
      "nginx.ingress.kubernetes.io/server-alias"      = "s1.52poke.wiki"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.wiki", "www.52poke.wiki", "s0.52poke.wiki", "s1.52poke.wiki", "util.52poke.wiki"]
      secret_name = "52poke-wiki-tls"
    }

    rule {
      host = "s0.52poke.wiki"

      http {
        path {
          path = "/"

          backend {
            service_name = "nginx-media"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-media" {
  metadata {
    name = "nginx-media"
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app = "nginx-media"
    }
  }
}

resource "kubernetes_deployment" "nginx-media" {
  metadata {
    name = "nginx-media"
  }

  spec {
    selector {
      match_labels = {
        app = "nginx-media"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-media"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "nginx-media"

          config_map {
            name = "nginx-media"
          }
        }

        volume {
          name = "nginx-media-persistent-storage"

          persistent_volume_claim {
            claim_name = "nginx-media-pvc"
          }
        }

        container {
          name  = "nginx-media"
          image = "mudkip/frontend-nginx:latest"
          resources {
            requests {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          port {
            container_port = 80
          }

          volume_mount {
            name       = "nginx-media"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }

          volume_mount {
            name       = "nginx-media-persistent-storage"
            mount_path = "/var/cache/nginx"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nginx-media-pvc" {
  metadata {
    name      = "nginx-media-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }

    storage_class_name = "linode-block-storage-retain"
  }
}
