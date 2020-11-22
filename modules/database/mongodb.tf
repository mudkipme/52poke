provider "mongodb" {
  host          = "mongodb"
  port          = "27017"
  username      = "root"
  auth_database = "admin"
}

resource "mongodb_db_user" "forums" {
  auth_database = "forums"
  name          = "forums"
  password      = var.mongodb_forums_password

  role {
    role = "dbOwner"
    db   = "forums"
  }
}

resource "mongodb_db_user" "paradise" {
  auth_database = "paradise"
  name          = "paradise"
  password      = var.mongodb_paradise_password

  role {
    role = "dbOwner"
    db   = "paradise"
  }
}