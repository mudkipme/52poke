provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "lke-meltan-cluster" {
  label       = "lke-meltan-cluster"
  k8s_version = "1.24"
  region      = "ap-northeast"
  tags        = ["52Poké"]

  pool {
    type  = "g6-standard-4"
    count = 2
  }

  pool {
    type  = "g6-standard-4"
    count = 0
    autoscaler {
      min = 0
      max = 1
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      pool,
    ]
  }
}

resource "local_file" "kubeconfig" {
  content_base64 = linode_lke_cluster.lke-meltan-cluster.kubeconfig
  filename       = "${path.root}/.kubeconfig"
}

data "external" "static-pool-ips" {
  program = flatten(["python3", "${path.root}/scripts/instance-ips.py", var.linode_token, linode_lke_cluster.lke-meltan-cluster.pool[0].nodes.*.instance_id])
}
