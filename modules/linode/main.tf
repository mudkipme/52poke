provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "lke-meltan-cluster" {
  label       = "lke-meltan-cluster"
  k8s_version = "1.18"
  region      = "ap-northeast"
  tags        = ["52Poké"]

  pool {
    type  = "g6-standard-2"
    count = 3
  }

  pool {
    type  = "g6-standard-2"
    count = 1
  }
}

resource "local_file" "kubeconfig" {
  content_base64 = linode_lke_cluster.lke-meltan-cluster.kubeconfig
  filename       = "${path.root}/.kubeconfig"
}

locals {
  instance_ids = flatten([
    for pool in linode_lke_cluster.lke-meltan-cluster.pool : pool.nodes.*.instance_id
  ])
}

data "external" "instance-ips" {
  program = flatten(["python3", "${path.root}/scripts/instance-ips.py", var.linode_token, local.instance_ids])
}
