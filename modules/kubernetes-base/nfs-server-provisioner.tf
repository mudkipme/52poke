resource "helm_release" "nfs-server-provisioner" {
  name       = "nfs-server-provisioner"
  repository = "https://charts.helm.sh/stable"
  chart      = "nfs-server-provisioner"

  values = [
    templatefile("${path.root}/helm/nfs-server-provisioner/values.yaml", {
      pool_id = var.pool_ids[0]
    })
  ]
}
