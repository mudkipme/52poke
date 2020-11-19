resource "null_resource" "lke-nodes-bootstrap" {
  count = length(var.instance_ids)

  triggers = {
    id = element(var.instance_ids, count.index)
  }

  connection {
    host = element(var.instance_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "apt install -y open-iscsi"
    ]
  }
}
