provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "lke-meltan-cluster" {
  label       = "lke-meltan-cluster"
  k8s_version = "1.20"
  region      = "ap-northeast"
  tags        = ["52Poké"]

  pool {
    type  = "g6-standard-2"
    count = 3
  }

  pool {
    type  = "g6-standard-2"
    count = 1
    autoscaler {
      min = 1
      max = 5
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # https://github.com/linode/terraform-provider-linode/issues/198
      pool[0].count,
      pool[1].count
    ]
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

data "external" "static-pool-ips" {
  program = flatten(["python3", "${path.root}/scripts/instance-ips.py", var.linode_token, linode_lke_cluster.lke-meltan-cluster.pool[0].nodes.*.instance_id])
}
