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
