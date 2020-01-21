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

variable "cf_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
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

variable "s3_additional_allow_ips" {
  type        = list(string)
  description = "Additional IP addresses allowed to access S3"
  default     = []
}

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
}