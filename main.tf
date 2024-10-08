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
  source          = "./modules/linode"
  linode_token    = var.linode_token
  authorized_keys = var.authorized_keys
}

module "aws" {
  source = "./modules/aws"
  allow_ips = concat(
    module.linode.instance_ipv4,
    module.linode.instance_ipv6
  )
}

module "cloudflare" {
  source           = "./modules/cloudflare"
  cf_token_dns     = var.cf_token_dns
  load_balancer_ip = module.linode.load_balancer_ip
}

module "kubernetes-apps" {
  source                        = "./modules/kubernetes-apps"
  depends_on                    = [module.kubernetes-base]
  cf_zone_id                    = module.cloudflare.cf_zone_id
  cf_token                      = var.cf_token
  malasada_api_id               = module.aws.malasada_prod_id
  wiki_ban_user_agents          = var.wiki_ban_user_agents
  wiki_ban_uri                  = var.wiki_ban_uri
  media_valid_referrers         = var.media_valid_referrers
  media_ban_user_agent          = var.media_ban_user_agent
  media_ban_empty_refer_uri     = var.media_ban_empty_refer_uri
}
