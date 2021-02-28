variable "cf_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "cf_token" {
  type        = string
  description = "Cloudflare API Token"
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


variable "klinklang_oauth_key" {
  type        = string
  description = "52Poké Wiki OAuth Consumer Key for Klinklang"
}

variable "klinklang_oauth_secret" {
  type        = string
  description = "52Poké Wiki OAuth Consumer Secret for Klinklang"
}

variable "wiki_52poke_secret_key" {
  type        = string
  description = "52Poké Wiki secret key"
}

variable "wiki_52poke_upgrade_key" {
  type        = string
  description = "52Poké Wiki upgrade key"
}

variable "recaptcha_site_key" {
  type        = string
  description = "reCAPTCHA site key"
}

variable "recaptcha_secret_key" {
  type        = string
  description = "reCAPTCHA secret key"
}

variable "aws_ses_access_key" {
  type        = string
  description = "AWS API access key for SES"
}

variable "aws_ses_secret_key" {
  type        = string
  description = "AWS API secret key for SES"
}

variable "discord_token" {
  type        = string
  description = "Discord bot token"
}