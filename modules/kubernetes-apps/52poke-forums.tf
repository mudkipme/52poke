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
