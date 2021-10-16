resource "kubernetes_secret" "authorized-keys" {
  metadata {
    name      = "authorized-keys"
    namespace = "kube-system"
  }

  data = {
    authorized_keys = join("\n", var.authorized_keys)
  }
}

resource "kubernetes_secret" "linode-credentials" {
  metadata {
    name      = "linode-credentials"
    namespace = "cert-manager"
  }

  data = {
    token = var.linode_token
  }
}

resource "kubernetes_secret" "linode-credentials-default" {
  metadata {
    name = "linode-credentials"
  }

  data = {
    token = var.linode_token
  }
}

resource "kubernetes_secret" "cloudflare-dns" {
  metadata {
    name      = "cloudflare-dns"
    namespace = "cert-manager"
  }

  data = {
    token = var.cf_token_dns
  }
}
