variable "cf_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "malasada_api_id" {
  type        = string
  description = "API Gateway API ID of malasada"
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

variable "pool_ids" {
  type        = list(string)
  description = "LKE Cluster Pool IDs"
}

variable "b2_account_id" {
  type        = string
  description = "B2 Account ID"
}

variable "b2_account_key" {
  type        = string
  description = "B2 Account Key"
}

variable "restic_password" {
  type        = string
  description = "Restic Backup Password"
}

variable "aws_s3_access_key" {
  type        = string
  description = "AWS API access key for S3"
}

variable "aws_s3_secret_key" {
  type        = string
  description = "AWS API secret key for S3"
}