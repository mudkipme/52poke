resource "kubernetes_namespace" "dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  namespace  = "kubernetes-dashboard"

  values = [
    file("${path.root}/helm/kubernetes-dashboard/values.yaml")
  ]
}

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard" {
  metadata {
    name = "kubernetes-dashboard"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "dashboard-kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}