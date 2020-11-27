resource "kubernetes_namespace" "local-path-storage" {
  metadata {
    name = "local-path-storage"
  }
}

resource "helm_release" "local-path-provisioner" {
  name      = "local-path-provisioner"
  chart     = "${path.root}/charts/local-path-provisioner"
  namespace = "local-path-storage"
}