variable "authorized_keys" {
  type        = list(string)
  description = "Authorized SSH Public Keys"
  default     = []
}

variable "linode_token" {
  type        = string
  description = "Linode API token"
}
