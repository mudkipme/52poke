provider "linode" {
  token = var.linode_token
}

resource "linode_lke_cluster" "lke-meltan-cluster" {
  label       = "lke-meltan-cluster"
  k8s_version = "1.22"
  region      = "ap-northeast"
  tags        = ["52Poké"]

  pool {
    type  = "g6-standard-2"
    count = 3
  }

  pool {
    type  = "g6-standard-2"
    count = 4
    autoscaler {
      min = 1
      max = 5
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
