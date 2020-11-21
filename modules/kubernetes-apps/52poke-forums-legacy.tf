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
