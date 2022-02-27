resource "kubernetes_ingress_v1" "forums_52poke_legacy" {
  metadata {
    name = "52poke-forums-legacy"
    annotations = {
      "cert-manager.io/cluster-issuer"        = "le-http-issuer"
      "nginx.ingress.kubernetes.io/use-regex" = "true"
      "kubernetes.io/ingress.class"           = "nginx"
      "ingressClassName"                      = "nginx"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.net", "www.52poke.net", "legacy.52poke.net", "media.52poke.net"]
      secret_name = "52poke-forums-tls"
    }

    rule {
      host = "legacy.52poke.net"

      http {
        # only allow static requests until security concerns are addressed
        path {
          path = "/(images|gallery)/.*"

          backend {
            service {
              name = "forums-52poke-legacy"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/upload/(month[0-9]+|usravatars)/.*"

          backend {
            service {
              name = "forums-52poke-legacy"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/.*\\.(gif|png|txt|jpg|jpeg)$"

          backend {
            service {
              name = "forums-52poke-legacy"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "forums_52poke_legacy" {
  metadata {
    name = "forums-52poke-legacy"
  }

  spec {
    port {
      port = 80
    }

    selector = {
      app = "52poke-forums-legacy"
    }
  }
}

resource "kubernetes_deployment" "forums_52poke_legacy" {
  metadata {
    name = "52poke-forums-legacy"
  }

  spec {
    selector {
      match_labels = {
        app = "52poke-forums-legacy"
      }
    }

    template {
      metadata {
        labels = {
          app = "52poke-forums-legacy"
        }
      }

      spec {
        volume {
          name = "52poke-forums-legacy-persistent-storage"

          persistent_volume_claim {
            claim_name = "pvc-52poke-forums-legacy"
          }
        }

        security_context {
          fs_group = 82
        }

        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        container {
          name  = "52poke-forums-legacy"
          image = "mudkip/52poke-forums-legacy:latest"
          resources {
            requests = {
              cpu    = "10m"
              memory = "128Mi"
            }
            limits = {
              memory = "256Mi"
            }
          }

          port {
            container_port = 80
          }

          env {
            name = "MYSQL_USERNAME"
            value_from {
              secret_key_ref {
                name = "mysql-legacyforums"
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql-legacyforums"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "52poke-forums-legacy-persistent-storage"
            mount_path = "/var/www/html"
          }

          command = ["/bin/sh", "-c", <<EOF
set -e
sed -i "s/\$db_username=.*/\$db_username=\"$MYSQL_USERNAME\";/g" /var/www/html/datafile/config.php
sed -i "s/\$db_password=.*/\$db_password=\"$MYSQL_PASSWORD\";/g" /var/www/html/datafile/config.php
/usr/bin/supervisord -c /etc/supervisord.conf
EOF  
          ]
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc-52poke-forums-legacy" {
  metadata {
    name      = "pvc-52poke-forums-legacy"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "4Gi"
      }
    }

    storage_class_name = "nfs"
  }
}
