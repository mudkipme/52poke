provider "mysql" {
  endpoint = "mariadb-pc:3306"
  alias    = "mariadb_pc"
}

resource "mysql_database" "mysql-pc-52poke-wiki" {
  provider              = mysql.mariadb_pc
  name                  = "52poke_wiki"
  default_character_set = "utf8"
  default_collation     = "utf8_general_ci"

  lifecycle {
    prevent_destroy = true
  }
}

resource "mysql_user" "pc-wiki" {
  provider           = mysql.mariadb_pc
  user               = "wiki"
  host               = "%"
  plaintext_password = var.mysql_wiki_password
}

resource "mysql_grant" "pc-wiki" {
  provider   = mysql.mariadb_pc
  user       = mysql_user.pc-wiki.user
  host       = "%"
  database   = mysql_database.mysql-pc-52poke-wiki.name
  privileges = ["ALL"]
}