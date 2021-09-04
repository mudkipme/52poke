resource "kubernetes_secret" "authorized-keys" {
  metadata {
    name      = "authorized-keys"
    namespace = "kube-system"
  }

  data = {
    authorized_keys = join("\n", var.authorized_keys)
  }
}

resource "kubernetes_secret" "linode-credentials" {
  metadata {
    name      = "linode-credentials"
    namespace = "cert-manager"
  }

  data = {
    token = var.linode_token
  }
}

resource "kubernetes_secret" "linode-credentials-default" {
  metadata {
    name = "linode-credentials"
  }

  data = {
    token = var.linode_token
  }
}

resource "kubernetes_secret" "cloudflare-dns" {
  metadata {
    name      = "cloudflare-dns"
    namespace = "cert-manager"
  }

  data = {
    token = var.cf_token_dns
  }
}

resource "kubernetes_secret" "cluster-autoscaler-cloud-config" {
  metadata {
    name      = "cluster-autoscaler-cloud-config"
    namespace = "kube-system"
  }

  data = {
    cloud-config = templatefile("${path.root}/config/cluster-autoscaler/cloud-config", {
      ignore_pool_id = var.pool_ids[0],
      linode_token   = var.linode_token,
      cluster_id     = var.cluster_id
    })
  }
}