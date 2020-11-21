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

  values = [
    templatefile("${path.root}/helm/ingress-nginx/values.yaml", {
      pool_id = var.pool_ids[0]
    })
  ]
}

data "external" "load-balancer-ip" {
  depends_on  = [helm_release.ingress-nginx]
  program     = ["sh", "${path.root}/scripts/get-external-ip.sh"]
  working_dir = path.root
}
