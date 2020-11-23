resource "kubernetes_ingress" "forums_52poke" {
  metadata {
    name = "52poke-forums"
    annotations = {
      "cert-manager.io/cluster-issuer" = "le-wildcard-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["52poke.net", "*.52poke.net"]
      secret_name = "52poke-forums-tls"
    }

    rule {
      host = "52poke.net"

      http {
        path {
          path = "/"

          backend {
            service_name = "forums-52poke"
            service_port = "4567"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "forums_52poke" {
  metadata {
    name = "forums-52poke"
  }

  spec {
    port {
      port = 4567
    }

    selector = {
      app = "52poke-forums"
    }
  }
}

resource "kubernetes_deployment" "forums_52poke" {
  metadata {
    name = "52poke-forums"
  }

  spec {
    selector {
      match_labels = {
        app = "52poke-forums"
      }
    }

    template {
      metadata {
        labels = {
          app = "52poke-forums"
        }
      }

      spec {
        node_selector = {
          "lke.linode.com/pool-id" = var.pool_ids[0]
        }

        volume {
          name = "52poke-forums-persistent-storage"

          persistent_volume_claim {
            claim_name = "pvc-52poke-forums"
          }
        }

        security_context {
          fs_group = 1000
        }

        container {
          name  = "52poke-forums"
          image = "mudkip/nodebb:latest"
          resources {
            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          port {
            name           = "nodebb"
            container_port = 4567
          }

          env {
            name = "AWS_ACCESS_KEY_ID"
            value_from {
              secret_key_ref {
                name = "aws-s3"
                key  = "accessKeyID"
              }
            }
          }

          env {
            name = "AWS_SECRET_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = "aws-s3"
                key  = "secretAccessKey"
              }
            }
          }

          env {
            name  = "S3_UPLOADS_BUCKET"
            value = "media.52poke.com"
          }

          env {
            name  = "S3_UPLOADS_PATH"
            value = "/forums/upload"
          }

          env {
            name  = "mongo__host"
            value = "mongodb"
          }

          env {
            name = "mongo__username"
            value_from {
              secret_key_ref {
                name = "mongodb-forums"
                key  = "username"
              }
            }
          }

          env {
            name = "mongo__password"
            value_from {
              secret_key_ref {
                name = "mongodb-forums"
                key  = "password"
              }
            }
          }

          env {
            name  = "redis__host"
            value = "redis"
          }

          volume_mount {
            name       = "52poke-forums-persistent-storage"
            mount_path = "/usr/src/app"
          }

          command = ["node", "./nodebb", "dev"]
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc-52poke-forums" {
  metadata {
    name      = "pvc-52poke-forums"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "3Gi"
      }
    }

    storage_class_name = "nfs"
  }
}
