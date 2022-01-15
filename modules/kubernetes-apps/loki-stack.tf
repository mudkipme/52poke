resource "kubernetes_namespace" "logs" {
  metadata {
    name = "logs"
  }
}

resource "helm_release" "loki-stack" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.4.1"
  namespace  = "logs"

  values = [
    templatefile("${path.root}/helm/loki-stack/values.yaml", {
      pool_id = var.pool_ids[0]
    })
  ]
}