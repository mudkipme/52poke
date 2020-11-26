variable "cf_token_dns" {
  type        = string
  description = "Cloudflare API Token for DNS Record Editing"
}

variable "load_balancer_ip" {
  type        = string
  description = "IP Address of Linode NodeBalancer"
}