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
  version    = "v1.7.1"
  values = [
    templatefile("${path.root}/helm/cert-manager/values.yaml", {
      pool_id = var.pool_ids[0]
    })
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
  chart      = "https://github.com/slicen/cert-manager-webhook-linode/releases/download/v0.2.0/cert-manager-webhook-linode-v0.2.0.tgz"
  namespace  = "cert-manager"
  set {
    name  = "api.groupName"
    value = "52poke.com"
  }

  set {
    name  = "deployment.logLevel"
    value = ""
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