resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"

  values = [
    templatefile("${path.root}/helm/mongodb/values.yaml", {
      mongodb_password = random_password.mongodb_password.result
    })
  ]
}