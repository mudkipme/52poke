terraform {
  required_providers {
    mysql = {
      source = "terraform-providers/mysql"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
    mongodb = {
      source = "kaginari/mongodb"
    }
  }
  required_version = ">= 0.13"
}
