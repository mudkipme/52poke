resource "kubernetes_job" "wiki-52poke-es-init" {
  metadata {
    name = "52poke-wiki-es-init"
  }

  spec {
    template {
      metadata {}

      spec {
        volume {
          name = "52poke-wiki-config"

          config_map {
            name = "52poke-wiki"
          }
        }

        volume {
          name = "mysql-user"

          secret {
            secret_name = "mysql-wiki"
          }
        }

        volume {
          name = "52poke-wiki-secret"

          secret {
            secret_name = "52poke-wiki"
          }
        }

        volume {
          name = "52poke-wiki-oauth2"

          secret {
            secret_name = "52poke-wiki-oauth2"
          }
        }

        volume {
          name = "aws-s3"

          secret {
            secret_name = "aws-s3"
          }
        }

        volume {
          name = "aws-ses"

          secret {
            secret_name = "aws-ses"
          }
        }

        volume {
          name = "recaptcha"

          secret {
            secret_name = "recaptcha"
          }
        }

        container {
          name  = "52poke-wiki"
          image = "ghcr.io/mudkipme/mediawiki:latest"

          resources {
            limits = {
              memory = "1Gi"
            }
            requests = {
              cpu    = "150m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "52poke-wiki-config"
            read_only  = true
            mount_path = "/home/52poke/wiki/LocalSettings.php"
            sub_path   = "LocalSettings.php"
          }

          volume_mount {
            name       = "mysql-user"
            read_only  = true
            mount_path = "/run/secrets/52w-db-user"
            sub_path   = "username"
          }

          volume_mount {
            name       = "mysql-user"
            read_only  = true
            mount_path = "/run/secrets/52w-db-password"
            sub_path   = "password"
          }

          volume_mount {
            name       = "52poke-wiki-secret"
            read_only  = true
            mount_path = "/run/secrets/52w-secret-key"
            sub_path   = "secretKey"
          }

          volume_mount {
            name       = "52poke-wiki-secret"
            read_only  = true
            mount_path = "/run/secrets/52w-upgrade-key"
            sub_path   = "upgradeKey"
          }

          volume_mount {
            name       = "aws-s3"
            read_only  = true
            mount_path = "/run/secrets/aws-s3-ak"
            sub_path   = "accessKeyID"
          }

          volume_mount {
            name       = "aws-s3"
            read_only  = true
            mount_path = "/run/secrets/aws-s3-sk"
            sub_path   = "secretAccessKey"
          }

          volume_mount {
            name       = "aws-ses"
            read_only  = true
            mount_path = "/run/secrets/aws-smtp-ak"
            sub_path   = "accessKeyID"
          }

          volume_mount {
            name       = "aws-ses"
            read_only  = true
            mount_path = "/run/secrets/aws-smtp-sk"
            sub_path   = "secretAccessKey"
          }

          volume_mount {
            name       = "recaptcha"
            read_only  = true
            mount_path = "/run/secrets/recaptcha-site-key"
            sub_path   = "siteKey"
          }

          volume_mount {
            name       = "recaptcha"
            read_only  = true
            mount_path = "/run/secrets/recaptcha-secret-key"
            sub_path   = "secretKey"
          }

          volume_mount {
            name       = "52poke-wiki-oauth2"
            read_only  = true
            mount_path = "/run/secrets/oauth2"
          }

          image_pull_policy = "Always"
          command = ["/bin/sh", "-c", <<EOF
set -e
cd /home/52poke/wiki/maintenance
php update.php
cd /home/52poke/wiki/extensions/CirrusSearch/maintenance
php UpdateSearchIndexConfig.php --reindexAndRemoveOk --indexIdentifier=now
php ForceSearchIndex.php --skipLinks --indexOnSkip
php ForceSearchIndex.php --skipParse
EOF
          ]
        }
      }
    }
  }
}