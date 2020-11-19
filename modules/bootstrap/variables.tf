variable "instance_ids" {
  type        = list(string)
  description = "LKE instance IDs"
  default     = []
}

variable "instance_ipv4" {
  type        = list(string)
  description = "LKE instance IPs"
  default     = []
}
