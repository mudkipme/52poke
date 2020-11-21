output "load_balancer_ip" {
  value = data.external.load-balancer-ip.result.ip
}