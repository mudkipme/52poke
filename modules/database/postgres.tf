provider "postgresql" {
  host     = "postgres"
  port     = 5432
  username = "postgres"
  password = var.postgres_password
  sslmode  = "disable"
}

resource "postgresql_database" "klinklang" {
  name = "klinklang"
}

resource "postgresql_database" "pokeapi" {
  name = "pokeapi"
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