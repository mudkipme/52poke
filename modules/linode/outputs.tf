output "instance_ids" {
  value = linode_lke_cluster.lke-meltan-cluster.pool[0].nodes.*.instance_id
}

output "kubeconfig" {
  value = local_file.kubeconfig.filename
}

output "instance_ipv4" {
  value = split(",", data.external.instance-ips.result.ipv4)
}

output "instance_ipv6" {
  value = split(",", data.external.instance-ips.result.ipv6)
}
