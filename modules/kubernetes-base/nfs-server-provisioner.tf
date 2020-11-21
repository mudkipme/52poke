resource "helm_release" "nfs-server-provisioner" {
  name       = "nfs-server-provisioner"
  repository = "https://charts.helm.sh/stable"
  chart      = "nfs-server-provisioner"

  values = [
    file("${path.root}/helm/nfs-server-provisioner/values.yaml")
  ]
}
