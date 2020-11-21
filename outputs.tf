output "instance_ids" {
  value = module.linode.instance_ids
}

output "instance_ipv4" {
  value = module.linode.instance_ipv4
}

output "instance_ipv6" {
  value = module.linode.instance_ipv6
}

output "load_balancer_ip" {
  value = module.kubernetes-base.load_balancer_ip
}