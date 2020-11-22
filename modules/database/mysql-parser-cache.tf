provider "mysql" {
  endpoint = "mysql-pc:3306"
  alias    = "mysql_pc"
}

resource "mysql_database" "mysql-pc-52poke-wiki" {
  provider              = mysql.mysql_pc
  name                  = "52poke_wiki"
  default_character_set = "utf8"
  default_collation     = "utf8_general_ci"

  lifecycle {
    prevent_destroy = true
  }
}

resource "mysql_user" "pc-wiki" {
  provider           = mysql.mysql_pc
  user               = "wiki"
  host               = "%"
  plaintext_password = var.mysql_wiki_password
}

resource "mysql_grant" "pc-wiki" {
  provider   = mysql.mysql_pc
  user       = mysql_user.pc-wiki.user
  host       = "%"
  database   = mysql_database.mysql-pc-52poke-wiki.name
  privileges = ["ALL"]
}