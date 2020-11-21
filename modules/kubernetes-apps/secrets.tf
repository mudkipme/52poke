resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mysql-root" {
  metadata {
    name = "mysql-root"
  }

  data = {
    username = "root"
    password = random_password.mysql_password.result
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

resource "random_password" "postgres_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name = "postgres"
  }

  data = {
    username = "postgres"
    password = random_password.postgres_password.result
  }
}

resource "random_password" "mongodb_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
