variable "linode_token" {
  type        = string
  description = "Linode API token"
}

variable "aws_access_key" {
  type        = string
  description = "AWS API access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS API secret key"
}

variable "cf_token" {
  type        = string
  description = "Cloudflare API Token for Cache Purging"
}

variable "cf_token_dns" {
  type        = string
  description = "Cloudflare API Token for DNS Record Editing"
}

variable "wiki_ban_user_agents" {
  type        = list(string)
  description = "Denied user agents for 52Poké Wiki"
  default     = []
}

variable "wiki_ban_uri" {
  type        = list(string)
  description = "Denied URIs for 52Poké Wiki"
  default     = []
}

variable "media_ban_user_agent" {
  type        = list(string)
  description = "Denied user agents for media.52poke.com"
  default     = []
}

variable "media_ban_empty_refer_uri" {
  type        = list(string)
  description = "Denied URIs for media.52poke.com when the referrer is empty"
  default     = []
}

variable "media_valid_referrers" {
  type        = string
  description = "Valid referrers for media.52poke.com"
  default     = "52poke.com *.52poke.com 52poke.wiki *.52poke.wiki 52poke.net *.52poke.net"
}

variable "internal_github_domain" {
  type        = string
  description = "GitHub mail domain allowed to visit internal services"
}

variable "internal_github_client_id" {
  type        = string
  description = "GitHub OAuth Client ID"
}

variable "internal_github_client_secret" {
  type        = string
  description = "GitHub OAuth Client Secret"
}

variable "authorized_keys" {
  type        = list(string)
  description = "Authorized SSH Public Keys"
  default     = []
}
