resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "3.11.0"

  values = [
    templatefile("${path.root}/helm/ingress-nginx/values.yaml", {
      pool_id            = var.pool_ids[0],
      load_balancer_ip   = var.load_balancer_ip,
      load_balancer_ipv6 = var.load_balancer_ipv6,
      http_port          = var.http_port,
      https_port         = var.https_port,
    })
  ]
}