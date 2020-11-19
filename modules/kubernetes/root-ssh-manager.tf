# credits: https://github.com/asauber/dssh

resource "kubernetes_daemonset" "root-ssh-manager" {
  metadata {
    name      = "root-ssh-manager"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        app = "root-ssh-manager"
      }
    }

    template {
      metadata {
        labels = {
          app = "root-ssh-manager"
        }
      }

      spec {
        volume {
          name = "root"

          host_path {
            path = "/root"
          }
        }

        volume {
          name = "ssh-keys"

          secret {
            secret_name = "authorized-keys"
          }
        }

        container {
          name    = "update-ssh-authorized-keys"
          image   = "busybox:latest"
          command = ["/bin/sh", "-c", "set -o errexit\nset -o xtrace\numask 0077\nwhile true\ndo\n  mkdir -p /mnt/root/.ssh\n  rm -f /mnt/root/.ssh/authorized_keys_new\n  for key in $(find /mnt/keys -type f); do (cat $${key}; echo) >> /mnt/root/.ssh/authorized_keys_new; done\n  mv /mnt/root/.ssh/authorized_keys_new /mnt/root/.ssh/authorized_keys\n  sleep 60s;\ndone\n"]

          volume_mount {
            name       = "root"
            mount_path = "/mnt/root"
          }

          volume_mount {
            name       = "ssh-keys"
            mount_path = "/mnt/keys"
            read_only  = true
          }

          security_context {
            privileged = true
          }
        }
      }
    }
  }
}

