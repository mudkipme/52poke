resource "kubernetes_ingress" "kibana" {
  metadata {
    name = "kibana"

    annotations = {
      "cert-manager.io/cluster-issuer"          = "le-http-issuer"
      "nginx.ingress.kubernetes.io/auth-url"    = "https://auth.internal.52poke.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin" = "https://auth.internal.52poke.com/oauth2/start?rd=https://$host$escaped_request_uri"
    }
  }

  spec {
    tls {
      hosts       = ["kibana.internal.52poke.com"]
      secret_name = "internal-tls"
    }

    rule {
      host = "kibana.internal.52poke.com"

      http {
        path {
          backend {
            service_name = "kibana"
            service_port = "5601"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "kibana" {
  metadata {
    name = "kibana"
  }

  spec {
    port {
      port = 5601
    }

    selector = {
      app = "kibana"
    }
  }
}

resource "kubernetes_deployment" "kibana" {
  metadata {
    name = "kibana"
  }

  spec {
    selector {
      match_labels = {
        app = "kibana"
      }
    }

    template {
      metadata {
        labels = {
          app = "kibana"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "kibana"
          image = "kibana:7.9.3"

          resources {
            requests {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          port {
            container_port = 5601
          }

          env {
            name  = "ELASTICSEARCH_HOSTS"
            value = "http://elasticsearch-logging.default.svc.cluster.local:9200"
          }

          env {
            name  = "xpack.security.enabled"
            value = "false"
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}
