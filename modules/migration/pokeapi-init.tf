resource "kubernetes_job" "pokeapi-init" {
  count = 0
  
  depends_on = [kubernetes_job.database-init]
  metadata {
    name = "pokeapi-init"
  }

  spec {
    template {
      metadata {}

      spec {
        volume {
          name = "config-pokeapi"

          config_map {
            name = "config-pokeapi"
          }
        }

        container {
          name  = "pokeapi"
          image = "mudkip/pokeapi:latest"
          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = "postgres-pokeapi"
                key  = "username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "postgres-pokeapi"
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "config-pokeapi"
            mount_path = "/code/config/docker-compose.py"
            sub_path   = "pokeapi.py"
          }

          command = ["/bin/sh", "-c", <<EOF
python manage.py migrate --settings=config.docker-compose
echo "from data.v2.build import build_all; build_all()" | python manage.py shell
EOF
          ]
        }

        restart_policy = "Never"
      }
    }
  }
}