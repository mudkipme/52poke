resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"

  values = [
    templatefile("${path.root}/helm/kube-prometheus-stack/values.yaml", {
      grafana_password = random_password.grafana_password.result,
    })
  ]
}