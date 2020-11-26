locals {
  terraform_database_files = fileset("${path.root}/modules/database", "*.tf")
}

resource "kubernetes_config_map" "terraform-database" {
  metadata {
    name = "terraform-database"
  }

  data = zipmap(local.terraform_database_files, [for filename in local.terraform_database_files : file("${path.root}/modules/database/${filename}")])
}