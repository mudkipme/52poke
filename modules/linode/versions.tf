terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
