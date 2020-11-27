resource "random_integer" "http_port" {
  min = 30000
  max = 32000
}

locals {
  https_port = random_integer.http_port.result + 443 - 80
}

resource "linode_stackscript" "load-balancer" {
  label       = "load-balancer"
  description = "Bootstrap a Load Balancer"
  script      = file("${path.root}/scripts/load-balancer.sh")
  images      = ["linode/ubuntu20.04"]
  rev_note    = "initial version"
}

resource "linode_instance" "load-balancer" {
  image           = "linode/ubuntu20.04"
  label           = "load-balancer"
  region          = "ap-northeast"
  type            = "g6-nanode-1"
  authorized_keys = var.authorized_keys
  tags            = ["52Poké"]
  private_ip      = true

  stackscript_id = linode_stackscript.load-balancer.id
  stackscript_data = {
    "http_port"   = random_integer.http_port.result,
    "https_port"  = local.https_port,
    "private_ips" = replace(data.external.instance-ips.result.private, ",", " ")
  }
}
