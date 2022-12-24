terraform {
  required_providers {
    mysql = {
      source = "petoju/mysql"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
  required_version = ">= 0.13"
}
