resource "kubernetes_secret" "mysql-root" {
  metadata {
    name = "mysql-root"
  }

  data = {
    username = "root"
    password = var.mysql_root_password
  }
}

resource "random_password" "oauth2-proxy-secret" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "internal-github-oauth" {
  metadata {
    name      = "internal-github-oauth"
    namespace = "kube-system"
  }

  data = {
    "client-id"     = var.internal_github_client_id
    "client-secret" = var.internal_github_client_secret
    "cookie-secret" = random_password.oauth2-proxy-secret.result
  }
}

resource "kubernetes_secret" "authorized-keys" {
  metadata {
    name      = "authorized-keys"
    namespace = "kube-system"
  }

  data = {
    authorized_keys = join("\n", var.authorized_keys)
  }
}