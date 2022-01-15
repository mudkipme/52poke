resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = [""]
    resources  = ["services", "endpoints", "pods"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["list"]
    api_groups = [""]
    resources  = ["nodes"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
  metadata {
    name = "external-dns-viewer"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "external-dns"
    namespace = "default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-dns"
  }
}

resource "kubernetes_deployment" "external_dns" {
  metadata {
    name = "external-dns"
  }

  spec {
    selector {
      match_labels = {
        app = "external-dns"
      }
    }

    template {
      metadata {
        labels = {
          app = "external-dns"
        }
      }

      spec {
        automount_service_account_token = true

        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "external-dns"
          image = "k8s.gcr.io/external-dns/external-dns:v0.7.4"
          args  = ["--source=ingress", "--domain-filter=52poke.com", "--domain-filter=52poke.net", "--domain-filter=baokemeng.com", "--provider=linode"]

          env {
            name = "LINODE_TOKEN"
            value_from {
              secret_key_ref {
                name = "linode-credentials"
                key  = "token"
              }
            }
          }
        }

        service_account_name = "external-dns"
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}