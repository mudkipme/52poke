terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    linode = {
      source = "linode/linode"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
