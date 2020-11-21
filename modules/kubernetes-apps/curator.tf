resource "kubernetes_cron_job" "curator" {
  metadata {
    name = "curator"
  }

  spec {
    schedule = "1 0 * * *"

    job_template {
      metadata {
        labels = {
          "app" = "curator"
        }
      }

      spec {
        template {
          metadata {
            labels = {
              "app" = "curator"
            }
          }

          spec {
            container {
              name  = "curator"
              image = "bitnami/elasticsearch-curator"
              args  = ["--config", "/etc/es-curator/config.yml", "/etc/es-curator/action_file.yml"]
              volume_mount {
                name       = "config-volume"
                mount_path = "/etc/es-curator"
              }
            }

            volume {
              name = "config-volume"
              config_map {
                name = "curator"
              }
            }

            restart_policy = "Never"
          }
        }
      }
    }

    successful_jobs_history_limit = 1
  }
}
