resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.7.0"
  values = [
    templatefile("${path.root}/helm/metrics-server/values.yaml", {
      pool_id = var.pool_ids[0]
    })
  ]
}
