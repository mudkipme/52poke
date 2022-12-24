provider "postgresql" {
  host     = "postgres"
  port     = 5432
  username = "postgres"
  password = var.postgres_password
  sslmode  = "disable"
}

resource "postgresql_database" "klinklang" {
  name = "klinklang"

  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_database" "pokeapi" {
  name = "pokeapi"

  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_database" "forums" {
  name = "forums"

  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_database" "paradise" {
  name = "paradise"

  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_role" "klinklang" {
  name     = "klinklang"
  login    = true
  password = var.postgres_klinklang_password
}

resource "postgresql_role" "pokeapi" {
  name     = "pokeapi"
  login    = true
  password = var.postgres_pokeapi_password
}

resource "postgresql_role" "forums" {
  name     = "forums"
  login    = true
  password = var.postgres_forums_password
}

resource "postgresql_role" "paradise" {
  name     = "paradise"
  login    = true
  password = var.postgres_paradise_password
}

resource "postgresql_grant" "klinklang" {
  database    = postgresql_database.klinklang.name
  role        = postgresql_role.klinklang.name
  schema      = "public"
  object_type = "database"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "pokeapi" {
  database    = postgresql_database.pokeapi.name
  role        = postgresql_role.pokeapi.name
  schema      = "public"
  object_type = "database"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "forums" {
  database    = postgresql_database.forums.name
  role        = postgresql_role.forums.name
  schema      = "public"
  object_type = "database"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "paradise" {
  database    = postgresql_database.paradise.name
  role        = postgresql_role.paradise.name
  schema      = "public"
  object_type = "database"
  privileges  = ["ALL"]
}