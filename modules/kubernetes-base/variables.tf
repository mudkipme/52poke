variable "pool_ids" {
  type        = list(string)
  description = "LKE Cluster Pool IDs"
}

variable "authorized_keys" {
  type        = list(string)
  description = "Authorized SSH Public Keys"
  default     = []
}

variable "linode_token" {
  type        = string
  description = "Linode API token"
}

variable "cf_token_dns" {
  type        = string
  description = "Cloudflare API Token for DNS Record Editing"
}