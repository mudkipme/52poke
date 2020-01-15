provider "linode" {
    token = var.linode_token
}

module "linodes" {
    source = "./modules/linodes"
}