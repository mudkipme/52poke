terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 1.22.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
