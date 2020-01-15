resource "null_resource" "lke-nodes-bootstrap" {
    count = length(linode_instance.lke-meltan-linodes.*.id)

    triggers = {
        id = element(linode_instance.lke-meltan-linodes.*.id, count.index)
    }

    connection {
        host = element(linode_instance.lke-meltan-linodes.*.ip_address, count.index)
    }

    provisioner "remote-exec" {
        inline = [
            "apt install -y nfs-common"
        ]
    }
}