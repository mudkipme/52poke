provider "linode" {
  token = var.linode_token
}

provider "aws" {
  region     = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "linodes" {
  source = "./modules/linodes"
}

module "lambda" {
  source = "./modules/lambda"
}

module "s3" {
  source    = "./modules/s3"
  allow_ips = module.linodes.instance_ips
}