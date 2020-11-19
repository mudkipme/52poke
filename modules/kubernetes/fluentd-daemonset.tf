resource "kubernetes_service_account" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "fluentd" {
  metadata {
    name = "fluentd"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "namespaces"]
  }
}

resource "kubernetes_cluster_role_binding" "fluentd" {
  metadata {
    name = "fluentd"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "fluentd"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fluentd"
  }
}

resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name      = "fluentd"
    namespace = "kube-system"

    labels = {
      k8s-app = "fluentd-logging"
      version = "v1"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "fluentd-logging"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "fluentd-logging"
          version = "v1"
        }
      }

      spec {
        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        automount_service_account_token = true

        container {
          name  = "fluentd"
          image = "fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch"

          env {
            name  = "FLUENT_ELASTICSEARCH_HOST"
            value = "elasticsearch-logging.default.svc.cluster.local"
          }

          env {
            name  = "FLUENT_ELASTICSEARCH_PORT"
            value = "9200"
          }

          env {
            name  = "FLUENT_ELASTICSEARCH_SCHEME"
            value = "http"
          }

          env {
            name  = "FLUENTD_SYSTEMD_CONF"
            value = "disable"
          }

          env {
            name  = "FLUENT_CONTAINER_TAIL_PARSER_TYPE"
            value = "json_in_json"
          }

          resources {
            limits {
              memory = "200Mi"
            }

            requests {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = "fluentd"

        toleration {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      }
    }
  }
}