resource "kubernetes_ingress" "paradise_52poke_legacy" {
  metadata {
    name = "52poke-paradise-legacy"
    annotations = {
      "cert-manager.io/cluster-issuer" = "le-wildcard-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["*.52poke.com"]
      secret_name = "wildcard-52poke-tls"
    }

    rule {
      host = "paradise.52poke.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "paradise-52poke-legacy"
            service_port = "1012"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "paradise_52poke_legacy" {
  metadata {
    name = "paradise-52poke-legacy"
  }

  spec {
    port {
      port = 1012
    }

    selector = {
      app = "52poke-paradise-legacy"
    }
  }
}

resource "kubernetes_deployment" "paradise_52poke_legacy" {
  metadata {
    name = "52poke-paradise-legacy"
  }

  spec {
    selector {
      match_labels = {
        app = "52poke-paradise-legacy"
      }
    }

    template {
      metadata {
        labels = {
          app = "52poke-paradise-legacy"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "52poke-paradise-legacy-persistent-storage"

          persistent_volume_claim {
            claim_name = "pvc-52poke-paradise-legacy"
          }
        }

        container {
          name  = "52poke-paradise-legacy"
          image = "mudkip/52poke-paradise-legacy:latest"
          resources {
            requests {
              cpu    = "50m"
              memory = "128Mi"
            }
            limits {
              memory = "384Mi"
            }
          }

          port {
            container_port = 1012
          }

          env {
            name = "MONGO_USERNAME"
            value_from {
              secret_key_ref {
                name = "mongodb-paradise"
                key  = "username"
              }
            }
          }

          env {
            name = "MONGO_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongodb-paradise"
                key  = "password"
              }
            }
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
            name       = "52poke-paradise-legacy-persistent-storage"
            mount_path = "/app"
          }

          command = ["/bin/sh", "-c", <<EOF
set -e
sed -i "s/mongodb.*\/paradise/mongodb:\/\/$MONGO_USERNAME:$MONGO_PASSWORD@mongodb\/paradise/g" config.json
sed -i "s/\"dbUser\": \".*\"/\"dbUser\": \"$MYSQL_USERNAME\"/g" config.json
sed -i "s/\"dbPass\": \".*\"/\"dbPass\": \"$MYSQL_PASSWORD\"/g" config.json
sed -i "s/redis-52poke-forums/redis/g" ./app/session-handler.js
node bin/www
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

resource "kubernetes_persistent_volume_claim" "pvc-52poke-paradise-legacy" {
  metadata {
    name      = "pvc-52poke-paradise-legacy"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "2Gi"
      }
    }

    storage_class_name = "nfs"
  }
}
