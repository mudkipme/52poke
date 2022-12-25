output "kubeconfig" {
  value = local_file.kubeconfig.filename
}

output "instance_ipv4" {
  value = split(",", data.external.static-pool-ips.result.ipv4)
}

output "instance_ipv6" {
  value = split(",", data.external.static-pool-ips.result.ipv6)
}

output "instance_private" {
  value = split(",", data.external.static-pool-ips.result.private)
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

output "load_balancer_ipv6" {
  value = split("/", linode_instance.load-balancer.ipv6)[0]
}

output "mysql_port" {
  value = random_integer.mysql_port.result
}

output "mysql_pc_port" {
  value = local.mysql_pc_port
}

output "cluster_id" {
  value = linode_lke_cluster.lke-meltan-cluster.id
}