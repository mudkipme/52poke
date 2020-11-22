resource "kubernetes_secret" "authorized-keys" {
  metadata {
    name      = "authorized-keys"
    namespace = "kube-system"
  }

  data = {
    authorized_keys = join("\n", var.authorized_keys)
  }
}