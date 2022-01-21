resource "kubernetes_ingress" "nginx-52w" {
  metadata {
    name = "nginx-52w"
    annotations = {
      "cert-manager.io/cluster-issuer"                = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/enable-access-log" = "false"
      "nginx.ingress.kubernetes.io/proxy-body-size"   = "16m"
    }
  }

  spec {
    tls {
      hosts       = ["wiki.52poke.com"]
      secret_name = "wiki-52poke-tls"
    }

    rule {
      host = "wiki.52poke.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "nginx-52w"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "nginx-52w-wiki" {
  metadata {
    name = "nginx-52w-wiki"
    annotations = {
      "cert-manager.io/cluster-issuer"             = "le-cloudflare-issuer"
      "nginx.ingress.kubernetes.io/server-alias"   = "www.52poke.wiki"
      "nginx.ingress.kubernetes.io/rewrite-target" = "https://wiki.52poke.com/wiki/$1"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.wiki", "www.52poke.wiki", "s0.52poke.wiki", "s1.52poke.wiki", "util.52poke.wiki"]
      secret_name = "52poke-wiki-tls"
    }

    rule {
      host = "52poke.wiki"

      http {
        path {
          path = "/(.*)"

          backend {
            service_name = "nginx-52w"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-52w" {
  metadata {
    name = "nginx-52w"
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app = "nginx-52w"
    }
  }
}

resource "kubernetes_deployment" "nginx-52w" {
  metadata {
    name = "nginx-52w"
  }

  spec {
    selector {
      match_labels = {
        app = "nginx-52w"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-52w"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "nginx-52w"

          config_map {
            name = "nginx-52w"
          }
        }

        volume {
          name = "nginx-52w-persistent-storage"

          persistent_volume_claim {
            claim_name = "nginx-52w-pvc"
          }
        }

        container {
          name  = "nginx-52w"
          image = "mudkip/frontend-nginx:latest"
          resources {
            requests = {
              cpu    = "200m"
              memory = "512Mi"
            }
          }

          port {
            container_port = 80
          }

          volume_mount {
            name       = "nginx-52w"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }

          volume_mount {
            name       = "nginx-52w-persistent-storage"
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

resource "kubernetes_persistent_volume_claim" "nginx-52w-pvc" {
  metadata {
    name      = "nginx-52w-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "20Gi"
      }
    }

    storage_class_name = "linode-block-storage"
  }
}
