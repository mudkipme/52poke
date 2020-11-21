output "instance_ids" {
  value = local.instance_ids
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

output "pool_ids" {
  value = linode_lke_cluster.lke-meltan-cluster.pool.*.id
}
