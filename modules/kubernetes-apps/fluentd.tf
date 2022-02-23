resource "kubernetes_service" "fluentd" {
  metadata {
    name = "logstash"
  }

  spec {
    port {
      name = "fluentd-52w"
      port = 5001
    }

    selector = {
      app = "timburr"
    }
  }
}
