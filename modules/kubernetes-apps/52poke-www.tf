resource "kubernetes_ingress_v1" "www_52poke" {
  metadata {
    name = "52poke-www"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = "le-wildcard-issuer"
      "nginx.ingress.kubernetes.io/from-to-www-redirect" = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size"      = "16m"
      "kubernetes.io/ingress.class"                      = "nginx"
      "ingressClassName"                                 = "nginx"
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
            service {
              name = "www-52poke"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "baokemeng" {
  metadata {
    name = "baokemeng"
    annotations = {
      "cert-manager.io/cluster-issuer"                   = "le-http-issuer"
      "nginx.ingress.kubernetes.io/from-to-www-redirect" = "true"
      "nginx.ingress.kubernetes.io/temporal-redirect"    = "https://www.portal-pokemon.com/"
      "kubernetes.io/ingress.class"                      = "nginx"
      "ingressClassName"                                 = "nginx"
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
            service {
              name = "www-52poke"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
