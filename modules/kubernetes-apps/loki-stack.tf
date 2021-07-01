resource "kubernetes_namespace" "logs" {
  metadata {
    name = "logs"
  }
}

resource "helm_release" "loki-stack" {
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = "logs"

  values = [
    file("${path.root}/helm/loki-stack/values.yaml")
  ]
}