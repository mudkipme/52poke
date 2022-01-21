resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  version    = "10.0.5"

  values = [
    templatefile("${path.root}/helm/mongodb/values.yaml", {
      mongodb_password = random_password.mongodb_password.result,
      pool_id          = var.pool_ids[0]
    })
  ]
}
