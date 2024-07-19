resource "random_password" "mysql-legacyforums-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mysql-legacyforums" {
  metadata {
    name = "mysql-legacyforums"
  }

  data = {
    username = "legacyforums"
    password = random_password.mysql-legacyforums-password.result
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

resource "random_password" "postgres-pokeapi-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "postgres-pokeapi" {
  metadata {
    name = "postgres-pokeapi"
  }

  data = {
    username = "pokeapi"
    password = random_password.postgres-pokeapi-password.result
  }
}

resource "random_password" "mongodb_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "mongodb-forums-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mongodb-forums" {
  metadata {
    name = "mongodb-forums"
  }

  data = {
    username = "forums"
    password = random_password.mongodb-forums-password.result
  }
}

resource "random_password" "mongodb-paradise-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mongodb-paradise" {
  metadata {
    name = "mongodb-paradise"
  }

  data = {
    username = "paradise"
    password = random_password.mongodb-paradise-password.result
  }
}

resource "random_password" "grafana_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}