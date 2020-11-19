resource "kubernetes_ingress" "kibana" {
  metadata {
    name = "kibana"

    annotations = {
      "cert-manager.io/cluster-issuer"          = "le-http-issuer"
      "nginx.ingress.kubernetes.io/auth-url"    = "https://internal.52poke.com/oauth2/auth"
      "nginx.ingress.kubernetes.io/auth-signin" = "https://internal.52poke.com/oauth2/start?rd=$escaped_request_uri"
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
            name  = "elasticsearch.hosts"
            value = "elasticsearch-logging.default.svc.cluster.local"
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