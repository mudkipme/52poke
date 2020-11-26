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
  values = [
    file("${path.root}/helm/cert-manager/values.yaml")
  ]
}

resource "null_resource" "le_http_issuer" {
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

resource "helm_release" "cert-manager-webhook-linode" {
  depends_on = [helm_release.cert-manager]
  name       = "cert-manager-webhook-linode"
  chart      = "${path.root}/charts/cert-manager-webhook-linode"
  namespace  = "cert-manager"
  set {
    name  = "api.groupName"
    value = "52poke.com"
  }
}

resource "null_resource" "le_wildcard_issuer" {
  depends_on = [helm_release.cert-manager-webhook-linode]
  triggers = {
    issuer_yaml = file("${path.root}/helm/cert-manager/le-wildcard-issuer.yaml")
  }

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl apply -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl delete -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }
}

resource "null_resource" "le_cloudflare_issuer" {
  depends_on = [helm_release.cert-manager]
  triggers = {
    issuer_yaml = file("${path.root}/helm/cert-manager/le-cloudflare-issuer.yaml")
  }

  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl apply -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl delete -f - <<EOF\n${self.triggers.issuer_yaml}\nEOF"
  }
}