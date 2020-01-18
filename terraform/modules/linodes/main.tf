resource "linode_instance" "lke-meltan-linodes" {
  count      = 2
  region     = "us-central"
  type       = "g6-standard-2"
  private_ip = true

  config {
    label       = "My Kubernetes 1.16.2 on Debian 9 Profile"
    kernel      = "linode/grub2"
    root_device = "/dev/sda"
    devices {
      sda {
        disk_label = "Kubernetes 1.16.2 on Debian 9 Disk"
      }
      sdb {
        disk_label = "512 MB Swap Image"
      }
    }
  }

  disk {
    label = "Kubernetes 1.16.2 on Debian 9 Disk"
    size  = "81408"
  }
  disk {
    label = "512 MB Swap Image"
    size  = "512"
  }
}
