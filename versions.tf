terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    linode = {
      source = "linode/linode"
    }
  }
  required_version = ">= 0.13"
}
