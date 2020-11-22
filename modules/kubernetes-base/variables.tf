variable "pool_ids" {
  type        = list(string)
  description = "LKE Cluster Pool IDs"
}

variable "authorized_keys" {
  type        = list(string)
  description = "Authorized SSH Public Keys"
  default     = []
}