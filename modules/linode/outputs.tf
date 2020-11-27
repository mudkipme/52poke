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

output "instance_private" {
  value = split(",", data.external.instance-ips.result.private)
}

output "pool_ids" {
  value = linode_lke_cluster.lke-meltan-cluster.pool.*.id
}

output "http_port" {
  value = random_integer.http_port.result
}

output "https_port" {
  value = local.https_port
}

output "load_balancer_ip" {
  value = linode_instance.load-balancer.ip_address
}