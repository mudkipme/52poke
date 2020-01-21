resource "linode_instance" "lke-meltan-linodes" {
  count      = 2
  region     = "us-central"
  type       = "g6-standard-2"
  private_ip = true

  config {
    label       = "Boot Config"
    kernel      = "linode/grub2"
    root_device = "/dev/sda"
    devices {
      sda {
        disk_label = "Boot Disk"
      }
    }
  }

  disk {
    label = "Boot Disk"
    size  = "81920"
  }
}
