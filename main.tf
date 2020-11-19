provider "aws" {
  region     = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "kubernetes" {
  config_path = "${path.root}/.kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/.kubeconfig"
  }
}

module "linode" {
  source       = "./modules/linode"
  linode_token = var.linode_token
}

module "bootstrap" {
  source        = "./modules/bootstrap"
  depends_on    = [module.linode]
  instance_ids  = module.linode.instance_ids
  instance_ipv4 = module.linode.instance_ipv4
}

module "lambda" {
  source = "./modules/lambda"
}

module "kubenetes" {
  source                        = "./modules/kubernetes"
  depends_on                    = [module.linode]
  cf_zone_id                    = var.cf_zone_id
  malasada_api_id               = module.lambda.malasada_prod_id
  wiki_ban_user_agents          = var.wiki_ban_user_agents
  wiki_ban_uri                  = var.wiki_ban_uri
  media_valid_referrers         = var.media_valid_referrers
  media_ban_user_agent          = var.media_ban_user_agent
  media_ban_empty_refer_uri     = var.media_ban_empty_refer_uri
  mysql_root_password           = var.mysql_root_password
  internal_github_domain        = var.internal_github_domain
  internal_github_client_id     = var.internal_github_client_id
  internal_github_client_secret = var.internal_github_client_secret
  authorized_keys               = var.authorized_keys
}

module "s3" {
  source = "./modules/s3"
  allow_ips = concat(
    module.linode.instance_ipv4,
    module.linode.instance_ipv6,
    var.s3_additional_allow_ips
  )
}
