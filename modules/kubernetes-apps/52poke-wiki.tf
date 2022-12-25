resource "kubernetes_horizontal_pod_autoscaler" "wiki-52poke" {
  metadata {
    name = "52poke-wiki"
  }

  spec {
    min_replicas = 1
    max_replicas = 8

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "52poke-wiki"
    }

    target_cpu_utilization_percentage = 100
  }
}
