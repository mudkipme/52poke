resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  namespace  = "longhorn-system"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"

  values = [
    file("${path.root}/helm/longhorn/values.yaml")
  ]
}