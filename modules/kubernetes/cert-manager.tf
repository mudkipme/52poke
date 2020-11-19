resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "1.0.4"
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "null_resource" "le_wildcard_issuer" {
  depends_on = [helm_release.cert-manager]
  triggers = {
    issuer_yaml = file("${path.root}/helm/cert-manager/le-http-issuer.yaml")
  }

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl apply -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl delete -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }
}
