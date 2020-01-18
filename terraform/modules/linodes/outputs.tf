output "instance_ips" {
  value = concat(
    linode_instance.lke-meltan-linodes.*.ip_address,
    [for ipv6 in linode_instance.lke-meltan-linodes.*.ipv6 : trimsuffix(ipv6, "/64")]
  )
}