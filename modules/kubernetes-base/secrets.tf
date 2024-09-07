resource "kubernetes_secret" "authorized-keys" {
  metadata {
    name      = "authorized-keys"
    namespace = "kube-system"
  }

  data = {
    authorized_keys = join("\n", var.authorized_keys)
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
