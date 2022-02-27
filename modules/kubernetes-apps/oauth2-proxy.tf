resource "kubernetes_ingress_v1" "oauth2-proxy" {
  metadata {
    name      = "oauth2-proxy"
    namespace = "kube-system"
    annotations = {
      "cert-manager.io/cluster-issuer" = "le-http-issuer"
      "kubernetes.io/ingress.class"    = "nginx"
      "ingressClassName"               = "nginx"
    }
  }

  spec {
    tls {
      hosts       = ["auth.internal.52poke.com"]
      secret_name = "oauth2-proxy-tls"
    }

    rule {
      host = "auth.internal.52poke.com"

      http {
        path {
          path = "/oauth2"

          backend {
            service {
              name = "oauth2-proxy"
              port {
                number = 4180
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "oauth2-proxy" {
  metadata {
    name      = "oauth2-proxy"
    namespace = "kube-system"

    labels = {
      k8s-app = "oauth2-proxy"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        k8s-app = "oauth2-proxy"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "oauth2-proxy"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "oauth2-proxy"
          image = "quay.io/oauth2-proxy/oauth2-proxy:latest"
          args  = ["--provider=github", "--whitelist-domain=.internal.52poke.com", "--email-domain=${var.internal_github_domain}", "--upstream=file:///dev/null", "--http-address=0.0.0.0:4180"]

          port {
            container_port = 4180
            protocol       = "TCP"
          }

          env {
            name = "OAUTH2_PROXY_CLIENT_ID"
            value_from {
              secret_key_ref {
                name = "internal-github-oauth"
                key  = "client-id"
              }
            }
          }

          env {
            name = "OAUTH2_PROXY_CLIENT_SECRET"
            value_from {
              secret_key_ref {
                name = "internal-github-oauth"
                key  = "client-secret"
              }
            }
          }

          env {
            name = "OAUTH2_PROXY_COOKIE_SECRET"
            value_from {
              secret_key_ref {
                name = "internal-github-oauth"
                key  = "cookie-secret"
              }
            }
          }

          env {
            name  = "OAUTH2_PROXY_COOKIE_DOMAINS"
            value = "internal.52poke.com"
          }

          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes_service" "oauth2-proxy" {
  metadata {
    name      = "oauth2-proxy"
    namespace = "kube-system"

    labels = {
      k8s-app = "oauth2-proxy"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 4180
      target_port = "4180"
    }

    selector = {
      k8s-app = "oauth2-proxy"
    }
  }
}

