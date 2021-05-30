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

resource "kubernetes_secret" "mysql-server" {
  metadata {
    name = "mysql-server"
  }

  data = {
    username = "root"
    password = var.mysql_password
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

resource "random_password" "postgres-klinklang-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "postgres-klinklang" {
  metadata {
    name = "postgres-klinklang"
  }

  data = {
    username = "klinklang"
    password = random_password.postgres-klinklang-password.result
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

resource "kubernetes_secret" "aws_s3" {
  metadata {
    name = "aws-s3"
  }

  data = {
    accessKeyID     = var.aws_s3_access_key
    secretAccessKey = var.aws_s3_secret_key
  }
}

resource "kubernetes_secret" "cloudflare" {
  metadata {
    name = "cloudflare"
  }

  data = {
    token = var.cf_token
  }
}

resource "random_uuid" "klinklang-secret-uuid" {}

resource "kubernetes_secret" "klinklang" {
  metadata {
    name = "klinklang"
  }

  data = {
    secret            = random_uuid.klinklang-secret-uuid.result
    wiki-oauth-key    = var.klinklang_oauth_key
    wiki-oauth-secret = var.klinklang_oauth_secret
  }
}

resource "kubernetes_secret" "wiki_52poke" {
  metadata {
    name = "52poke-wiki"
  }

  data = {
    secretKey  = var.wiki_52poke_secret_key
    upgradeKey = var.wiki_52poke_upgrade_key
  }
}

resource "kubernetes_secret" "aws_ses" {
  metadata {
    name = "aws-ses"
  }

  data = {
    accessKeyID     = var.aws_ses_access_key
    secretAccessKey = var.aws_ses_secret_key
  }
}

resource "kubernetes_secret" "recaptcha" {
  metadata {
    name = "recaptcha"
  }

  data = {
    siteKey   = var.recaptcha_site_key
    secretKey = var.recaptcha_secret_key
  }
}

resource "kubernetes_secret" "discord_52poke" {
  metadata {
    name = "52poke-discord"
  }

  data = {
    token = var.discord_token
  }
}

resource "random_password" "mysql-makeawish-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubernetes_secret" "mysql-makeawish" {
  metadata {
    name = "mysql-makeawish"
  }

  data = {
    username = "makeawish"
    password = random_password.mysql-makeawish-password.result
  }
}

resource "random_password" "makeawish-key" {
  length  = 32
  special = false
}

resource "kubernetes_secret" "makeawish" {
  metadata {
    name = "makeawish"
  }

  data = {
    appKey = random_password.makeawish-key.result
  }
}
