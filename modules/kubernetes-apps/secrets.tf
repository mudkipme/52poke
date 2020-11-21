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

resource "random_password" "mysql-wiki-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mysql-wiki" {
  metadata {
    name = "mysql-wiki"
  }

  data = {
    username = "wiki"
    password = random_password.mysql-wiki-password.result
  }
}

resource "random_password" "mysql-www-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mysql-www" {
  metadata {
    name = "mysql-www"
  }

  data = {
    username = "www"
    password = random_password.mysql-www-password.result
  }
}

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

resource "kubernetes_secret" "backblaze_b2" {
  metadata {
    name = "backblaze-b2"
  }

  data = {
    b2-account-id  = var.b2_account_id
    b2-account-key = var.b2_account_key
  }
}

resource "kubernetes_secret" "restic" {
  metadata {
    name = "restic"
  }

  data = {
    password = var.restic_password
  }
}
