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
  source = "./modules/s3"
  allow_ips = concat(
    module.linodes.instance_ips,
    var.s3_additional_allow_ips
  )
}

module "kubenetes" {
  source                    = "./modules/kubernetes"
  cf_zone_id                = var.cf_zone_id
  malasada_api_id           = module.lambda.malasada_prod_id
  wiki_ban_user_agents      = var.wiki_ban_user_agents
  wiki_ban_uri              = var.wiki_ban_uri
  media_ban_user_agent      = var.media_ban_user_agent
  media_ban_empty_refer_uri = var.media_ban_empty_refer_uri
  mysql_root_password       = var.mysql_root_password
}