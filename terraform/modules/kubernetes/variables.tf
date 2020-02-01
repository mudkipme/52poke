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

variable "mysql_root_password" {
  type        = string
  description = "MySQL root password"
}

variable "media_valid_referrers" {
  type        = string
  description = "Valid referrers for media.52poke.com"
  default     = "52poke.com *.52poke.com 52poke.wiki *.52poke.wiki 52poke.net *.52poke.net"
}