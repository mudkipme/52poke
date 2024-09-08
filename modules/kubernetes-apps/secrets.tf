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
