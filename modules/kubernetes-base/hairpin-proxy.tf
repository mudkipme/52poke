resource "null_resource" "hairpin-proxy" {
  provisioner "local-exec" {
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl apply -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "KUBECONFIG=${path.root}/.kubeconfig kubectl delete -f https://raw.githubusercontent.com/compumike/hairpin-proxy/v0.2.1/deploy.yml"
  }
}
