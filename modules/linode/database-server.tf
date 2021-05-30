resource "random_integer" "mysql_port" {
  min = 10000
  max = 32000
}

locals {
  mysql_pc_port = random_integer.mysql_port.result + 2
}

resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "linode_stackscript" "database-server" {
  label       = "database-server"
  description = "Bootstrap a Database Server"
  script      = file("${path.root}/scripts/database-server.sh")
  images      = ["linode/ubuntu20.04"]
  rev_note    = "initial version"
}

resource "linode_instance" "database-server" {
  image           = "linode/ubuntu20.04"
  label           = "database-server"
  region          = "ap-northeast"
  type            = "g6-standard-2"
  authorized_keys = var.authorized_keys
  tags            = ["52Poké"]
  private_ip      = true

  stackscript_id = linode_stackscript.database-server.id
  stackscript_data = {
    "mysql_port"          = random_integer.mysql_port.result,
    "mysql_pc_port"       = local.mysql_pc_port,
    "mysql_root_password" = random_password.mysql_password.result
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      stackscript_data
    ]
  }
}
